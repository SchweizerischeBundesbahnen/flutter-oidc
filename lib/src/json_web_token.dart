import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:sbb_oidc/src/json_web_token_codec.dart';

/// See https://datatracker.ietf.org/doc/html/rfc7519
@sealed
@immutable
class JsonWebToken {
  const JsonWebToken({
    required this.header,
    required this.payload,
    required this.signature,
  });

  factory JsonWebToken.decode(String input) {
    return jwt.decode(input);
  }

  final Map<String, dynamic> header;
  final Map<String, dynamic> payload;
  final Uint8List signature;

  /// The signature algorithm that was used to create the signature.
  String get algorithm => header['alg'] as String;

  /// The type of the token.
  String get type => header['typ'] as String;

  /// The subject claim identifies the principal that is the subject of the JWT.
  /// The claims in a JWT are normally statements about the subject.  The
  /// subject value MUST either be scoped to be locally unique in the context
  /// of the issuer or be globally unique.
  String get subject {
    return payload['sub'] as String;
  }

  /// The issued at claim identifies the time at which the JWT was issued. This
  /// claim can be used to determine the age of the JWT.
  DateTime get issuedAt {
    // Values is in seconds since epoch.
    final value = payload['iat'] as int;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  /// The not before claim identifies the time before which the JWT MUST NOT be
  /// accepted for processing. The processing of the claim requires that the
  /// current date/time MUST be after or equal to the not before date/time
  /// listed in the claim.
  DateTime get notBefore {
    // Values is in seconds since epoch.
    final value = payload['nbf'] as int;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  /// The expiration time claim identifies the expiration time on or after
  /// which the JWT MUST NOT be accepted for processing.  The processing of the
  /// claim requires that the current date/time MUST be before the expiration
  /// date/time listed in the claim.
  DateTime get expirationTime {
    // Values is in seconds since epoch.
    final value = payload['exp'] as int;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  /// The expired state of the JWT.
  bool get isExpired {
    final now = DateTime.now();
    return now.isAfter(expirationTime);
  }

  /// The not expired state of the JWT.
  bool get isNotExpired {
    return !isExpired;
  }

  /// Encodes this JWT to a string.
  String encode() {
    return jwt.encode(this);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JsonWebToken &&
        const MapEquality().equals(header, header) &&
        const MapEquality().equals(payload, payload) &&
        signature == other.signature;
  }

  @override
  int get hashCode {
    return Object.hash(
      const MapEquality().hash(header),
      const MapEquality().hash(payload),
      signature,
    );
  }

  @override
  String toString() {
    return "JWT(sub: $subject, expired: $isExpired)";
  }
}
