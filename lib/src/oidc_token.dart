import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'oidc_token.g.dart';

/// Authentication data returned by a successful login or token request.
///
/// OIDC tokens are sensitive credentials. Use them only for their intended
/// purpose and avoid logging, persisting, or serializing them outside of a
/// trusted boundary.
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@sealed
@immutable
class OidcToken {
  const OidcToken({
    required this.accessToken,
    this.accessTokenExpirationDateTime,
    required this.accessTokenType,
    this.idToken,
  });

  /// Creates an OIDC token from a JSON string.
  factory OidcToken.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return OidcToken.fromJson(json);
  }

  /// Creates an OIDC token from JSON.
  factory OidcToken.fromJson(Map<String, dynamic> json) {
    return _$OidcTokenFromJson(json);
  }

  /// The access token issued by the authorization server.
  ///
  /// Access tokens are short-lived and grant access to protected resources. Do
  /// not store or cache this token in the client application. Request a token
  /// from the OIDC client when needed so that the OIDC client can automatically
  /// refresh it when necessary.
  ///
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens
  final String accessToken;

  /// Indicates when the access token expires.
  final DateTime? accessTokenExpirationDateTime;

  /// The type of access token returned by the authorization server.
  final String accessTokenType;

  /// The ID token issued by the authorization server.
  ///
  /// An ID token contains identity claims about the authenticated user and is
  /// intended for the client application. It is not an access token and must
  /// not be used to authorize requests to protected APIs.
  ///
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens
  final String? idToken;

  /// Converts this OIDC token to JSON.
  ///
  /// By default, the returned map contains sensitive token data. Do not log,
  /// persist, or expose it outside a trusted boundary. Set [masked] to `true`
  /// when the serialized data is intended for diagnostic output.
  Map<String, dynamic> toJson({bool masked = false}) {
    if (masked) {
      final copy = OidcToken(
        accessToken: accessToken.mask(),
        accessTokenExpirationDateTime: accessTokenExpirationDateTime,
        accessTokenType: accessTokenType,
        idToken: idToken?.mask(),
      );
      return copy.toJson();
    } else {
      return _$OidcTokenToJson(this);
    }
  }

  /// Converts this OIDC token to a JSON string.
  ///
  /// By default, the returned string contains sensitive token data. Do not
  /// log, persist, or expose it outside a trusted boundary. Set [masked] to
  /// `true` when the serialized data is intended for diagnostic output.
  String toJsonString({bool masked = false, bool pretty = false}) {
    final encoder = JsonEncoder.withIndent(pretty ? ' ' * 2 : null);
    final json = toJson(masked: masked);
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OidcToken &&
        other.accessToken == accessToken &&
        other.accessTokenExpirationDateTime == accessTokenExpirationDateTime &&
        other.accessTokenType == accessTokenType &&
        other.idToken == idToken;
  }

  @override
  int get hashCode {
    return Object.hash(
      accessToken,
      accessTokenExpirationDateTime,
      accessTokenType,
      idToken,
    );
  }

  @override
  String toString() {
    final fields = [
      'accessToken: ${accessToken.mask()}',
      'accessTokenExpirationDateTime: $accessTokenExpirationDateTime',
      'accessTokenType: $accessTokenType',
      'idToken: ${idToken?.mask()}',
    ];
    return 'OidcToken(${fields.join(', ')})';
  }
}

extension _StringX on String {
  String mask() {
    const minimumLength = 12;
    if (length < minimumLength) {
      return '***';
    } else {
      const visibleCharacterCount = 4;
      final start = length - visibleCharacterCount;
      return '***${substring(start)}';
    }
  }
}
