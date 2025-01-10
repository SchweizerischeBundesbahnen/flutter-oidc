// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      sub: json['sub'] as String,
      name: json['name'] as String?,
      familyName: json['family_name'] as String?,
      givenName: json['given_name'] as String?,
      picture: json['picture'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'sub': instance.sub,
      'name': instance.name,
      'family_name': instance.familyName,
      'given_name': instance.givenName,
      'picture': instance.picture,
      'email': instance.email,
    };
