import 'package:json_annotation/json_annotation.dart';
import 'package:sbb_oidc_platform_interface/src/types/jwt/json_web_token.dart';

class JsonWebTokenConverter implements JsonConverter<JsonWebToken, String> {
  const JsonWebTokenConverter();

  @override
  JsonWebToken fromJson(String json) {
    return JsonWebToken.decode(json);
  }

  @override
  String toJson(JsonWebToken object) {
    return object.encode();
  }
}
