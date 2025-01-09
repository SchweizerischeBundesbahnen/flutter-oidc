import 'package:sbb_oidc/sbb_oidc.dart';

class NetworkException extends OidcException {
  const NetworkException({super.cause}) : super(message: 'Network error.');

  @override
  String toString() {
    return 'NetworkException($message)';
  }
}
