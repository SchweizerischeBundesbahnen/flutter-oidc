import 'package:sbb_oidc/sbb_oidc.dart';

class MultiFactorAuthenticationException extends OidcException {
  const MultiFactorAuthenticationException({super.cause})
      : super(message: 'The user must use multi-factor authentication.');

  @override
  String toString() {
    return 'MultiFactorAuthenticationException($message)';
  }
}
