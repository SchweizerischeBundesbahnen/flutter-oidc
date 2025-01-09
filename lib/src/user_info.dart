import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'user_info.g.dart';

/// Holds information about the signed in user.
///
/// Links:
/// - https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims
/// - https://openid.net/specs/openid-connect-core-1_0.html#UserInfo
/// - https://learn.microsoft.com/en-us/azure/active-directory/develop/userinfo
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
@sealed
@immutable
class UserInfo {
  const UserInfo({
    required this.sub,
    this.name,
    this.familyName,
    this.givenName,
    this.picture,
    this.email,
  });

  factory UserInfo.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return UserInfo.fromJson(json);
  }

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return _$UserInfoFromJson(json);
  }

  /// The subject identifier for the end user at the issuer.
  final String sub;

  /// The end user's full name in displayable form including all name parts.
  final String? name;

  /// The surname(s) or last name(s) of the end user.
  final String? familyName;

  /// The given name(s) or first name(s) of the end user.
  final String? givenName;

  /// The URL of the end user's profile picture.
  final String? picture;

  /// The end user's preferred e-mail address.
  final String? email;

  /// Converts this user info to json.
  Map<String, dynamic> toJson() {
    return _$UserInfoToJson(this);
  }

  /// Converts this user info to a json string.
  String toJsonString({bool pretty = false}) {
    final encoder = JsonEncoder.withIndent(pretty ? ' ' * 2 : null);
    final json = toJson();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserInfo &&
        other.sub == sub &&
        other.name == name &&
        other.familyName == familyName &&
        other.givenName == givenName &&
        other.picture == picture &&
        other.email == email;
  }

  @override
  int get hashCode {
    return Object.hash(
      sub,
      name,
      familyName,
      givenName,
      picture,
      email,
    );
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'UserInfo $jsonString';
  }
}
