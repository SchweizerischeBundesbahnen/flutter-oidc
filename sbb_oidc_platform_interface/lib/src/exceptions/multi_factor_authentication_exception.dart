import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class MultiFactorAuthenticationException extends OidcException {
  const MultiFactorAuthenticationException({super.cause})
      : super(message: 'The user must use multi-factor authentication.');

  @override
  String toString() {
    return 'MultiFactorAuthenticationException($message)';
  }
}
