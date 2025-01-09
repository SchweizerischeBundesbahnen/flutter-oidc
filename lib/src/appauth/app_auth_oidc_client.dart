import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:http/http.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc/src/appauth/platform_exception_x.dart';
import 'package:sbb_oidc/src/appauth/token_response_x.dart';
import 'package:sbb_oidc/src/token_store.dart';

class AppAuthOidcClient implements OidcClient {
  AppAuthOidcClient({
    required this.clientId,
    required this.httpClient,
    required this.postLogoutRedirectUrl,
    required this.providerConfiguration,
    required this.redirectUrl,
    required this.tokenStore,
  });

  final String clientId;
  final Client httpClient;
  final String? postLogoutRedirectUrl;
  final OpenIDProviderMetadata providerConfiguration;
  final String redirectUrl;
  final TokenStore tokenStore;

  final _appAuth = const FlutterAppAuth();

  AuthorizationServiceConfiguration get authorizationServiceConfiguration {
    return AuthorizationServiceConfiguration(
      authorizationEndpoint: providerConfiguration.authorizationEndpoint,
      tokenEndpoint: providerConfiguration.tokenEndpoint,
      endSessionEndpoint: providerConfiguration.endSessionEndpoint,
    );
  }

  @override
  Future<OidcToken> login({
    required List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  }) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }
    final token = await _authorizeInteractive(scopes, prompt, loginHint);
    final tokenKey = _generateTokenKey(scopes);
    await tokenStore.write(tokenKey, token);
    return token;
  }

  @override
  Future<OidcToken> getToken({
    required List<String> scopes,
    bool forceRefresh = false,
  }) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }
    // Get the token from the token store.
    final tokenKey = _generateTokenKey(scopes);
    OidcToken? token = await tokenStore.read(tokenKey);
    // Request a new token silently (no user interaction) if the token store
    // contains no token for the key.
    if (token == null) {
      final tokens = await tokenStore.readAll();
      if (tokens.isEmpty) {
        throw StateError('User is not authenticated.');
      }
      // Get all refresh tokens.
      final refreshTokens = <String>[];
      for (OidcToken token in tokens.values) {
        final refreshToken = token.refreshToken;
        if (refreshToken != null && refreshToken.isNotEmpty) {
          refreshTokens.add(refreshToken);
        }
      }
      if (refreshTokens.isEmpty) {
        throw StateError('No refresh tokens.');
      }
      token = await _authorizeSilent(refreshTokens, scopes);
      await tokenStore.write(tokenKey, token);
      return token;
    }
    // Return the token if not expired and refresh is not enforced.
    else if (token.isExpired == false && forceRefresh == false) {
      return token;
    }
    // Refresh the token.
    else {
      token = await _refreshToken(token.refreshToken!);
      await tokenStore.write(tokenKey, token);
      return token;
    }
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
    await tokenStore.deleteAll();
  }

  @override
  Future<void> endSession() async {
    final tokens = await tokenStore.readAll();
    if (tokens.isEmpty) return;
    // Get all id tokens
    final idTokens = <JsonWebToken>{};
    for (var oidcToken in tokens.values) {
      final idToken = oidcToken.idToken;
      idTokens.add(idToken);
    }
    // Delete all cached OIDC tokens.
    await tokenStore.deleteAll();
    // Call end session to delete browser cache.
    final request = EndSessionRequest(
      idTokenHint: idTokens.first.encode(),
      postLogoutRedirectUrl: postLogoutRedirectUrl,
      serviceConfiguration: authorizationServiceConfiguration,
    );
    try {
      await _appAuth.endSession(request);
    } on PlatformException catch (e) {
      // Convert platform exception to more specific exception.
      throw e.convert();
    }
  }

  String _generateTokenKey(List<String> scopes) {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }
    return [providerConfiguration.issuer, clientId, ...scopes].join(' ');
  }

  Future<OidcToken> _authorizeInteractive(
    List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  ) async {
    final request = AuthorizationTokenRequest(
      clientId,
      redirectUrl,
      serviceConfiguration: authorizationServiceConfiguration,
      scopes: scopes,
      promptValues: prompt == null ? null : [prompt.value],
      loginHint: loginHint,
    );
    try {
      final response = await _appAuth.authorizeAndExchangeCode(request);
      return response.oidcToken;
    } on PlatformException catch (e) {
      // Convert platform exception to more specific exception.
      throw e.convert();
    }
  }

  Future<OidcToken> _authorizeSilent(
    List<String> refreshTokens,
    List<String> scopes,
  ) async {
    final exceptions = <Exception>[];
    for (final refreshToken in refreshTokens) {
      final request = TokenRequest(
        clientId,
        redirectUrl,
        serviceConfiguration: authorizationServiceConfiguration,
        refreshToken: refreshToken,
        scopes: scopes,
      );
      try {
        final response = await _appAuth.token(request);
        return response.oidcToken;
      } on PlatformException catch (e) {
        // Convert platform exception to more specific exception.
        final exception = e.convert();
        exceptions.add(exception);
      }
    }
    throw exceptions;
  }

  Future<OidcToken> _refreshToken(
    String refreshToken,
  ) async {
    final request = TokenRequest(
      clientId,
      redirectUrl,
      serviceConfiguration: authorizationServiceConfiguration,
      refreshToken: refreshToken,
    );
    try {
      final response = await _appAuth.token(request);
      return response.oidcToken;
    } on PlatformException catch (e) {
      // Convert platform exception to more specific exception.
      throw e.convert();
    }
  }
}
