import 'package:json_annotation/json_annotation.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

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
