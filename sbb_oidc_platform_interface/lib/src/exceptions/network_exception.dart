import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class NetworkException extends OidcException {
  const NetworkException({super.cause}) : super(message: 'Network error.');

  @override
  String toString() {
    return 'NetworkException($message)';
  }
}
