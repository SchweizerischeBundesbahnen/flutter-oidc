import 'package:sbb_oidc/sbb_oidc.dart';

class MsalOidcClient implements OidcClient {
  @override
  Future<OidcToken> login({
    required List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<OidcToken> getToken({
    required List<String> scopes,
    bool forceRefresh = false,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<UserInfo> getUserInfo({
    required List<String> scopes,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> endSession() {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
