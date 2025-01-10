library;

import 'package:http/http.dart';
import 'package:sbb_oidc/src/appauth/app_auth_oidc_client.dart';
import 'package:sbb_oidc/src/oidc_client.dart';
import 'package:sbb_oidc/src/oidc_discovery.dart';
import 'package:sbb_oidc/src/token_store.dart';

export 'package:sbb_oidc/src/exceptions/login_canceled_exception.dart';
export 'package:sbb_oidc/src/exceptions/multi_factor_authentication_exception.dart';
export 'package:sbb_oidc/src/exceptions/network_exception.dart';
export 'package:sbb_oidc/src/exceptions/oidc_exception.dart';
export 'package:sbb_oidc/src/exceptions/refresh_token_expired_exception.dart';
export 'package:sbb_oidc/src/json_web_token.dart';
export 'package:sbb_oidc/src/login_prompt.dart';
export 'package:sbb_oidc/src/oidc_client.dart';
export 'package:sbb_oidc/src/oidc_token.dart';
export 'package:sbb_oidc/src/openid_provider_metadata.dart';
export 'package:sbb_oidc/src/sbb_discovery_url.dart';
export 'package:sbb_oidc/src/user_info.dart';

class SBBOpenIDConnect {
  const SBBOpenIDConnect._();

  /// Creates an OIDC client.
  ///
  /// Parameters:
  /// - [discoveryUrl]: The OpenID Connect discovery endpoint URL
  /// - [clientId]: The registered client identifier
  /// - [redirectUrl]: The URL where the server redirects after authentication
  /// - [postLogoutRedirectUrl]: Optional URL for redirect after logout
  /// - [httpClient]: Optional custom HTTP client for requests
  ///
  /// Returns a configured [OidcClient] ready for authentication operations.
  static Future<OidcClient> createClient({
    required String discoveryUrl,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
    Client? httpClient,
  }) async {
    // Get the OpenID Connect provider configuration from the discovery
    // endpoint.
    final providerConfiguration = await OidcDiscovery.getProviderConfiguration(
      httpClient: httpClient ?? Client(),
      discoveryUrl: discoveryUrl,
    );
    // Create and return the OIDC client.
    return AppAuthOidcClient(
      clientId: clientId,
      httpClient: httpClient ?? Client(),
      postLogoutRedirectUrl: postLogoutRedirectUrl,
      providerConfiguration: providerConfiguration,
      redirectUrl: redirectUrl,
      tokenStore: const TokenStore(),
    );
  }
}
