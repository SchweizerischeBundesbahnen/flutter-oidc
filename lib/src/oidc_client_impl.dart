import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc/src/platform_exception_x.dart';
import 'package:sbb_oidc/src/sbb_oidc_api.g.dart';
import 'package:sbb_oidc/src/user_info_request.dart';

class OidcClientImpl implements OidcClient {
  OidcClientImpl({
    required this._config,
    required this._hostApi,
    required this._log,
  });

  final OidcClientConfig _config;
  final SBBOidcHostApi _hostApi;
  final Logger? _log;

  Future<void> initialize() async {
    _log?.info('Initialize OIDC client');
    final parameters = InitializeParameters(
      clientId: _config.clientId,
      keychainAccessGroup: _config.keychainAccessGroup,
      redirectUri: _config.redirectUrl,
      tenantId: _config.tenantId,
    );
    await _hostApi.initialize(parameters);
  }

  @override
  Future<OidcToken> login({
    required List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  }) async {
    _log?.info('Login ${scopes.join(", ")}');
    try {
      final parameters = LoginParameters(
        loginHint: loginHint,
        prompt: prompt?.value,
        scopes: scopes,
      );
      final response = await _hostApi.login(parameters);
      return response.toOidcToken();
    } catch (e, s) {
      _log?.warning('Login failed', e, s);
      if (e is PlatformException) {
        throw e.convert();
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<OidcToken> getToken({
    required List<String> scopes,
    bool forceRefresh = false,
  }) async {
    _log?.info('Get token ${scopes.join(", ")}');
    final parameters = GetTokenParameters(
      forceRefresh: forceRefresh,
      scopes: scopes,
    );
    final response = await _hostApi.getToken(parameters);
    return response.toOidcToken();
  }

  @override
  Future<UserInfo> getUserInfo({required List<String> scopes}) async {
    _log?.info('Get user info ${scopes.join(", ")}');
    try {
      final request = UserInfoRequest(
        authorizationProvider: () async {
          final oidcToken = await getToken(scopes: scopes);
          return '${oidcToken.accessTokenType} ${oidcToken.accessToken}';
        },
        httpClient: Client(),
        userInfoEndpoint: 'https://graph.microsoft.com/oidc/userinfo',
      );
      final userInfo = await request.execute();
      return userInfo;
    } catch (e, s) {
      _log?.warning('Get user info failed', e, s);
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    _log?.info('Logout');
    try {
      await _hostApi.logout();
    } catch (e, s) {
      _log?.warning('Logout failed', e, s);
      rethrow;
    }
  }

  @override
  Future<void> endSession() async {
    _log?.info('End session');
    try {
      await _hostApi.endSession();
    } catch (e, s) {
      _log?.warning('End session failed', e, s);
      rethrow;
    }
  }
}

extension _OidcTokenResponseX on OidcTokenResponse {
  OidcToken toOidcToken() {
    return OidcToken(
      accessToken: accessToken,
      accessTokenExpirationDateTime: expiresOn?.toDateTime(),
      accessTokenType: authenticationScheme,
      idToken: idToken,
    );
  }
}

extension _StringX on String {
  DateTime? toDateTime() {
    return DateTime.tryParse(this);
  }
}
