import 'package:sbb_oidc/sbb_oidc.dart';

abstract class OidcClient {
  const OidcClient._();

  /// Start the login flow (OAuth 2.0 authorization code flow).
  ///
  /// Returns a [Future] which completes on success or terminates with an
  /// error if login fails or is canceled.
  Future<OidcToken> login({
    required List<String> scopes,
    LoginPrompt? prompt,
    String? loginHint,
  });

  /// Request a token for the specified scopes.
  ///
  /// Returns a [Future] which emits the token on success or terminates with an
  /// error.
  Future<OidcToken> getToken({
    required List<String> scopes,
    bool forceRefresh = false,
  });

  /// Get claims about the authenticated End-User.
  ///
  /// Returns a [Future] which emits the user info on success or terminates
  /// with an error.
  ///
  /// https://openid.net/specs/openid-connect-core-1_0.html#UserInfo
  Future<UserInfo> getUserInfo({
    required List<String> scopes,
  });

  /// Logout the current user locally .
  ///
  /// This method only performs a local logout by clearing stored tokens and
  /// session data. For a complete logout use [endSession] instead.
  ///
  /// Returns a [Future] that completes when the logout is finished.
  Future<void> logout();

  /// End the current session.
  ///
  /// Returns a [Future] that completes when endSession is finished.
  Future<void> endSession();
}
