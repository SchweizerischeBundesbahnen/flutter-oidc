/// Indicates the type of user interaction that is required to login.
enum LoginPrompt {
  /// This claim triggers the OAuth consent dialog after the user signs in. The
  /// dialog asks the user to grant permissions to the app.
  consent('consent'),

  /// This claim forces the user to enter his credentials on that request,
  /// which negates single sign-on.
  login('login'),

  /// This claim ensures that the user isn't presented with any interactive
  /// prompt and should be paired with a `login hint` to indicate which user
  /// must be signed in.
  ///
  /// If the request can't be completed silently via single sign-on, the login
  /// call returns an error.
  none('none'),

  /// This claim shows the user an account selector, negating silent SSO but
  /// allowing the user to pick which account he intend to sign in with,
  /// without requiring credential entry.
  selectAccount('select_account');

  // --------------------------------------------------------------------------

  const LoginPrompt(this.value);

  final String value;
}
