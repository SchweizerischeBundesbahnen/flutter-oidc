library sbb_oidc;

import 'package:http/http.dart';
import 'package:sbb_oidc/src/oidc_client.dart';
import 'package:sbb_oidc/src/oidc_client_impl.dart';
import 'package:sbb_oidc/src/oidc_discovery.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

export 'package:sbb_oidc/src/oidc_client.dart';
export 'package:sbb_oidc/src/sbb_discovery_url.dart';
export 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart'
    hide SBBOidcPlatform;

class SBBOpenIDConnect {
  const SBBOpenIDConnect._();

  static Future<OidcClient> createClient({
    required String discoveryUrl,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
  }) async {
    // Get the OpenID Connect provider configuration from the discovery
    // endpoint.
    final providerConfiguration = await OidcDiscovery.getProviderConfiguration(
      discoveryUrl: discoveryUrl,
    );

    // Create the platform specific OIDC service.
    final oidcService = SBBOidcPlatform.instance.oidcService(
      providerConfiguration: providerConfiguration,
      clientId: clientId,
      redirectUrl: redirectUrl,
      postLogoutRedirectUrl: postLogoutRedirectUrl,
    );

    // Create and return the OIDC client.
    return OidcClientImpl(
      httpClient: Client(),
      oidcService: oidcService,
      providerConfiguration: providerConfiguration,
    );
  }
}
