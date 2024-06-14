library sbb_oidc;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

class OidcClientImpl implements OidcClient {
  OidcClientImpl({
    required this.httpClient,
    required this.oidcService,
    required this.providerConfiguration,
  });

  final Client httpClient;
  final OidcService oidcService;
  final OpenIDProviderMetadata providerConfiguration;

  @override
  Future<OidcToken> login({
    required List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  }) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }
    return oidcService.login(scopes, prompt, loginHint);
  }

  @override
  Future<OidcToken> getToken({
    required List<String> scopes,
    bool forceRefresh = false,
  }) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }
    return oidcService.getToken(scopes, forceRefresh);
  }

  @override
  Future<UserInfo> getUserInfo({
    required List<String> scopes,
  }) async {
    // Get the OIDC token.
    final token = await getToken(scopes: scopes);
    // Request the user info.
    final url = Uri.parse(providerConfiguration.userinfoEndpoint);
    final response = await httpClient.get(
      url,
      headers: {
        'Authorization': '${token.tokenType} ${token.accessToken.value}',
      },
    );
    // Handle errors.
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'HTTP ${response.statusCode}: Get user info failed.',
        uri: url,
      );
    }
    // UTF-8 decode the response body to prevent decoding errors. This might
    // happen when the body contains diacritics and the content type header
    // does not specify an encoding (only application/json).
    final jsonString = utf8.decode(response.bodyBytes);
    return UserInfo.fromJsonString(jsonString);
  }

  @override
  Future<void> logout() async {
    await oidcService.logout();
  }

  @override
  Future<void> endSession() async {
    await oidcService.endSession();
  }
}
