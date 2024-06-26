import 'dart:async';

import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/auth/token_spec.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';

class AuthenticatorImpl implements Authenticator {
  AuthenticatorImpl({
    required this.oidcClient,
    required this.tokenSpecs,
  });

  final OidcClient oidcClient;
  final TokenSpecProvider tokenSpecs;

  @override
  Future<bool> get isAuthenticated async {
    try {
      final tokenSpec = tokenSpecs.first;
      await token(tokenSpec.id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<OidcToken> login({String? tokenId}) {
    TokenSpec? tokenSpec = tokenSpecs.getById(tokenId);
    tokenSpec ??= tokenSpecs.all.first;
    return oidcClient.login(
      scopes: tokenSpec.scopes,
      prompt: LoginPrompt.selectAccount,
    );
  }

  @override
  Future<OidcToken> token(String tokenId) async {
    final tokenSpec = tokenSpecs.getById(tokenId);
    if (tokenSpec == null) {
      throw ArgumentError.value(tokenId, 'tokenId', 'Unknown token id.');
    }
    return oidcClient.getToken(scopes: tokenSpec.scopes);
  }

  @override
  Future<UserInfo> userInfo() async {
    final tokenSpec = tokenSpecs.first;
    return oidcClient.getUserInfo(scopes: tokenSpec.scopes);
  }

  @override
  Future<void> logout() {
    return oidcClient.logout();
  }

  @override
  Future<void> endSession() {
    return oidcClient.endSession();
  }
}
