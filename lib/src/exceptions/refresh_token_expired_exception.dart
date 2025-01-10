import 'package:sbb_oidc/sbb_oidc.dart';

class RefreshTokenExpiredException extends OidcException {
  const RefreshTokenExpiredException({super.cause})
      : super(message: 'The refresh token has expired.');

  @override
  String toString() {
    return 'RefreshTokenExpiredException($message)';
  }
}
