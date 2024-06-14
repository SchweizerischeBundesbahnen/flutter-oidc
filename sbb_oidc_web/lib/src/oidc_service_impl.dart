import 'package:msal_js/msal_js.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';
import 'package:sbb_oidc_web/src/auth_exception_x.dart';
import 'package:sbb_oidc_web/src/authentication_result_x.dart';
import 'package:sbb_oidc_web/src/public_client_application_factory.dart';

class OidcServiceImpl extends OidcService {
  OidcServiceImpl._(this._pca);

  factory OidcServiceImpl({
    required OpenIDProviderMetadata providerConfiguration,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
  }) {
    final pca = PublicClientApplicationFactory.create(
      providerConfiguration: providerConfiguration,
      clientId: clientId,
      redirectUrl: redirectUrl,
    );

    // Set active account
    final activeAccount = pca.getActiveAccount();
    if (activeAccount == null) {
      final accounts = pca.getAllAccounts();
      if (accounts.isNotEmpty) {
        pca.setActiveAccount(accounts.first);
      }
    }

    return OidcServiceImpl._(pca);
  }

  final PublicClientApplication _pca;

  @override
  Future<OidcToken> login(
    List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  ) async {
    final request = PopupRequest();
    request.scopes = scopes;
    request.prompt = prompt?.value;
    request.loginHint = loginHint;

    late final AuthenticationResult result;
    try {
      result = await _pca.acquireTokenPopup(request);
    } on AuthException catch (e) {
      throw e.convert();
    }

    // Set the active account if not already set.
    if (_pca.getActiveAccount() == null) {
      _pca.setActiveAccount(result.account);
    }

    return result.oidcToken;
  }

  @override
  Future<OidcToken> getToken(List<String> scopes, bool forceRefresh) async {
    final request = SilentRequest();
    request.scopes = scopes;
    request.forceRefresh = forceRefresh;
    final result = await _pca.acquireTokenSilent(request);
    return result.oidcToken;
  }

  @override
  Future<void> logout() async {
    // https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/logout.md
    final request = EndSessionRequest();
    request.onRedirectNavigate = (url) {
      return false;
    };
    await _pca.logoutRedirect(request);
  }

  @override
  Future<void> endSession() {
    return _pca.logoutPopup();
  }
}
