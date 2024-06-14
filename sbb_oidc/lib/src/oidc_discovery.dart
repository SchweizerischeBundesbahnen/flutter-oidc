import 'dart:io';

import 'package:http/http.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

class OidcDiscovery {
  const OidcDiscovery._();

  /// Get the OpenID provider configuration.
  ///
  /// https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderConfig
  static Future<OpenIDProviderMetadata> getProviderConfiguration({
    required String discoveryUrl,
  }) async {
    // Request the OpenID connect provider configuration.
    final httpClient = Client();
    final url = Uri.parse(discoveryUrl);
    final response = await httpClient.get(url);
    final statusCode = response.statusCode;
    if (statusCode != HttpStatus.ok) {
      throw HttpException(
        'HTTP $statusCode: Get OpenID provider configuration failed.',
        uri: url,
      );
    }
    return OpenIDProviderMetadata.fromJsonString(response.body);
  }
}
