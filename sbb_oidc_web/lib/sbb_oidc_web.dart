import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';
import 'package:sbb_oidc_web/src/oidc_service_impl.dart';

class SBBOidcWeb extends SBBOidcPlatform {
  SBBOidcWeb();

  /// Registers this class as the default instance of [SBBOidcPlatform].
  static void registerWith(Registrar registrar) {
    SBBOidcPlatform.instance = SBBOidcWeb();
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
