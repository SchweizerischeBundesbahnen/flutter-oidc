import 'package:sbb_oidc_mobile/src/oidc_service_impl.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class SBBOidcMobile extends SBBOidcPlatform {
  SBBOidcMobile();

  /// Registers this class as the default instance of [SBBOidcPlatform].
  static void registerWith() {
    SBBOidcPlatform.instance = SBBOidcMobile();
  }

  @override
  OidcService oidcService({
    required OpenIDProviderMetadata providerConfiguration,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
  }) {
    return OidcServiceImpl(
      providerConfiguration: providerConfiguration,
      clientId: clientId,
      redirectUrl: redirectUrl,
      postLogoutRedirectUrl: postLogoutRedirectUrl,
    );
  }
}
