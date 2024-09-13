import 'package:flutter/services.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:sbb_oidc_mobile/src/platform_exception_x.dart';
import 'package:sbb_oidc_mobile/src/token_response_x.dart';
import 'package:sbb_oidc_mobile/src/token_store.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class OidcServiceImpl extends OidcService {
  OidcServiceImpl({
    required this.providerConfiguration,
    required this.clientId,
    required this.redirectUrl,
    required this.postLogoutRedirectUrl,
  });

  final OpenIDProviderMetadata providerConfiguration;
  final String clientId;
  final String redirectUrl;
  final String? postLogoutRedirectUrl;

  final _appAuth = const FlutterAppAuth();
  final _tokenStore = const TokenStore();

  AuthorizationServiceConfiguration get authorizationServiceConfiguration {
    return AuthorizationServiceConfiguration(
      authorizationEndpoint: providerConfiguration.authorizationEndpoint,
      tokenEndpoint: providerConfiguration.tokenEndpoint,
      endSessionEndpoint: providerConfiguration.endSessionEndpoint,
    );
  }

  @override
  Future<OidcToken> login(
    List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  ) async {
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }

    final token = await _authorizeInteractive(scopes, prompt, loginHint);
    final tokenKey = _generateTokenKey(scopes);
    await _tokenStore.write(tokenKey, token);

    return token;
  }

  @override
  Future<OidcToken> getToken(List<String> scopes, bool forceRefresh) async {
    // Validate arguments.
    if (scopes.isEmpty) {
      throw ArgumentError('Scopes must be not empty.');
    }

    // Get the token from the token store.
    final tokenKey = _generateTokenKey(scopes);
    OidcToken? token = await _tokenStore.read(tokenKey);

    // Request a new token silently (no user interaction) if the token store
    // contains no matching token.
    if (token == null) {
      final tokens = await _tokenStore.readAll();
      if (tokens.isEmpty) {
        throw StateError('Not authenticated.');
      }

      final refreshTokens = <String>[];
      for (OidcToken token in tokens.values) {
        final refreshToken = token.refreshToken;
        if (refreshToken != null && refreshToken.isNotEmpty) {
          refreshTokens.add(refreshToken);
        }
      }

      if (refreshTokens.isEmpty) {
        throw StateError('No refresh token.');
      }

      token = await _authorizeSilent(refreshTokens.first, scopes);
    }
    // Return the token if not expired and refresh is not enforced.
    else if (token.isExpired == false && forceRefresh == false) {
      return token;
    }
    // Refresh the token.
    else {
      token = await _refreshToken(token.refreshToken!);
    }

    await _tokenStore.write(tokenKey, token);
    return token;
  }

  @override
  Future<void> logout() async {
    await _tokenStore.deleteAll();
  }

  @override
  Future<void> endSession() async {
    final oidcTokens = await _tokenStore.readAll();
    if (oidcTokens.isEmpty) return;
    // Get all id tokens
    final idTokens = <JsonWebToken>{};
    for (var oidcToken in oidcTokens.values) {
      final idToken = oidcToken.idToken;
      idTokens.add(idToken);
    }
    // Delete all cached OIDC tokens.
    await _tokenStore.deleteAll();
    // Call end session to delete browser cache.
    final request = EndSessionRequest(
      idTokenHint: idTokens.first.encode(),
      postLogoutRedirectUrl: postLogoutRedirectUrl,
      serviceConfiguration: authorizationServiceConfiguration,
    );
    await _appAuth.endSession(request);
  }

  // Internal

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
    String refreshToken,
    List<String> scopes,
  ) async {
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
      throw e.convert();
    }
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
