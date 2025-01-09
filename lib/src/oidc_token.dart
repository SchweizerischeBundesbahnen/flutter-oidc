import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc/src/access_token_converter.dart';
import 'package:sbb_oidc/src/jwt/json_web_token_converter.dart';

part 'oidc_token.g.dart';

/// Holds authentication data after login.
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
  converters: [
    AccessTokenConverter(),
    JsonWebTokenConverter(),
  ],
)
@sealed
@immutable
class OidcToken {
  const OidcToken({
    required this.tokenType,
    required this.accessToken,
    this.accessTokenExpirationDateTime,
    this.refreshToken,
    required this.idToken,
  });

  factory OidcToken.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return OidcToken.fromJson(json);
  }

  factory OidcToken.fromJson(Map<String, dynamic> json) {
    return _$OidcTokenFromJson(json);
  }

  // The type of token returned by the authorization server.
  final String tokenType;

  /// The access token issued by the authorization server, and used by a client
  /// application in order to access a protected API.
  ///
  /// Access tokens are only valid for a short period of time. An authorization
  /// server may also issue a refresh token when the access token is issued.
  ///
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/access-tokens
  final AccessToken accessToken;

  /// Indicates when [accessToken] will expire.
  final DateTime? accessTokenExpirationDateTime;

  /// The refresh token issued by the authorization server.
  ///
  /// When a client acquires an access token to access a protected API, the
  /// client also receives a refresh token. The refresh token is used to obtain
  /// new access/refresh token pairs when the current access token expires.
  /// Refresh tokens are also used to acquire extra access tokens for other
  /// APIs.
  ///
  /// Refresh tokens can be revoked at any time. The client application must
  /// handle rejections gracefully when this occurs. This is done by sending
  /// the user to an interactive login prompt to sign in again.
  ///
  /// NOTE. On Web the refresh tokens are always null.
  ///
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/refresh-tokens
  final String? refreshToken;

  /// The ID token issued by the authorization server.
  ///
  /// ID tokens Contain claims that carry information about the user.
  /// Information in ID tokens allows the client to verify that a user is who
  /// they claim to be. The claims provided by ID tokens can be used for UX
  /// inside client applications.
  ///
  /// https://docs.microsoft.com/en-us/azure/active-directory/develop/id-tokens
  final JsonWebToken idToken;

  /// The expired state of the access token.
  bool? get isExpired {
    if (accessTokenExpirationDateTime == null) {
      return null;
    } else {
      final now = DateTime.now();
      return accessTokenExpirationDateTime!.isBefore(now);
    }
  }

  /// Converts this OIDC token to json.
  Map<String, dynamic> toJson() {
    return _$OidcTokenToJson(this);
  }

  /// Converts this OIDC token to a json string.
  String toJsonString({bool pretty = false}) {
    final encoder = JsonEncoder.withIndent(pretty ? ' ' * 2 : null);
    final json = toJson();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OidcToken &&
        tokenType == other.tokenType &&
        accessToken == other.accessToken &&
        accessTokenExpirationDateTime == other.accessTokenExpirationDateTime &&
        refreshToken == other.refreshToken &&
        idToken == other.idToken;
  }

  @override
  int get hashCode {
    return Object.hash(
      tokenType,
      accessToken,
      accessTokenExpirationDateTime,
      refreshToken,
      idToken,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'OidcToken $jsonString';
  }
}
