import 'package:meta/meta.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';

@sealed
@immutable
class const AuthenticatorConfig({
  required final String clientId,
  required final String keychainAccessGroup,
  required final String redirectUrl,
  required final String tenantId,
  required final TokenSpecProvider tokenSpecs,
}) {
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthenticatorConfig &&
        other.clientId == clientId &&
        other.keychainAccessGroup == keychainAccessGroup &&
        other.redirectUrl == redirectUrl &&
        other.tenantId == tenantId &&
        other.tokenSpecs == tokenSpecs;
  }

  @override
  int get hashCode {
    return Object.hash(clientId, keychainAccessGroup, redirectUrl, tenantId, tokenSpecs);
  }
}
