import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class RefreshTokenExpiredException extends OidcException {
  const RefreshTokenExpiredException({super.cause})
      : super(message: 'The refresh token has expired.');

  @override
  String toString() {
    return 'RefreshTokenExpiredException($message)';
  }
}
