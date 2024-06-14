import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

abstract class OidcService {
  OidcService();

  Future<OidcToken> login(
    List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  ) {
    throw UnimplementedError();
  }

  Future<OidcToken> getToken(List<String> scopes, bool forceRefresh) {
    throw UnimplementedError();
  }

  Future<void> logout() {
    throw UnimplementedError();
  }

  Future<void> endSession() {
    throw UnimplementedError();
  }
}
