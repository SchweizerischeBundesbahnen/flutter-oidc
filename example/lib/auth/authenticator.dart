import 'package:sbb_oidc/sbb_oidc.dart';

abstract class Authenticator {
  const Authenticator._();

  Future<bool> get isAuthenticated;

  Future<OidcToken> login({String? tokenId});

  Future<OidcToken> token(String tokenId);

  Future<UserInfo> userInfo();

  Future<void> logout();

  Future<void> endSession();
}
