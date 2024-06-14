import 'package:meta/meta.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

/// The access token issued by the authorization server, and used by a client
/// application in order to access a protected API.
///
/// Access tokens are only valid for a short period of time.
///
/// https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens
@immutable
@sealed
class AccessToken {
  const AccessToken(this.value);

  /// The access token value as opaque strings without a set format.
  final String value;

  /// `true` if this access token is a JWT, `false` otherwise.
  bool get isJsonWebToken {
    try {
      toJwt();
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Converts this access token to JWT, or throws an exception if this access
  /// token is not a JWT.
  JsonWebToken toJwt() {
    return JsonWebToken.decode(value);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AccessToken && other.value == value;
  }

  @override
  int get hashCode {
    return value.hashCode;
  }

  @override
  String toString() {
    return value;
  }
}
