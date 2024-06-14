import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class LoginCanceledException extends OidcException {
  const LoginCanceledException({super.cause})
      : super(message: 'The user has canceled the login flow.');

  @override
  String toString() {
    return 'LoginCanceledException($message)';
  }
}
