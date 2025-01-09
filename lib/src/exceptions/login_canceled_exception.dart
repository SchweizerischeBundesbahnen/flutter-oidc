import 'package:sbb_oidc/sbb_oidc.dart';

class LoginCanceledException extends OidcException {
  const LoginCanceledException({super.cause})
      : super(message: 'The user has canceled the login flow.');

  @override
  String toString() {
    return 'LoginCanceledException($message)';
  }
}
