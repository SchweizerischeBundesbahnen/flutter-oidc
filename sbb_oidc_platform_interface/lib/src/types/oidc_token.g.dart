// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OidcToken _$OidcTokenFromJson(Map<String, dynamic> json) => OidcToken(
      tokenType: json['token_type'] as String,
      accessToken:
          const AccessTokenConverter().fromJson(json['access_token'] as String),
      accessTokenExpirationDateTime:
          json['access_token_expiration_date_time'] == null
              ? null
              : DateTime.parse(
                  json['access_token_expiration_date_time'] as String),
      refreshToken: json['refresh_token'] as String?,
      idToken:
          const JsonWebTokenConverter().fromJson(json['id_token'] as String),
    );

Map<String, dynamic> _$OidcTokenToJson(OidcToken instance) => <String, dynamic>{
      'token_type': instance.tokenType,
      'access_token': const AccessTokenConverter().toJson(instance.accessToken),
      'access_token_expiration_date_time':
          instance.accessTokenExpirationDateTime?.toIso8601String(),
      'refresh_token': instance.refreshToken,
      'id_token': const JsonWebTokenConverter().toJson(instance.idToken),
    };
