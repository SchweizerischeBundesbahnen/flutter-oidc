import 'package:json_annotation/json_annotation.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

class AccessTokenConverter implements JsonConverter<AccessToken, String> {
  const AccessTokenConverter();

  @override
  AccessToken fromJson(String json) {
    return AccessToken(json);
  }

  @override
  String toJson(AccessToken object) {
    return object.value;
  }
}
