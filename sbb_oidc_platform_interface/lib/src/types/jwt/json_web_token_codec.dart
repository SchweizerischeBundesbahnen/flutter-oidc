import 'dart:convert';
import 'dart:typed_data';

import 'package:sbb_oidc_platform_interface/src/types/jwt/json_web_token.dart';

const jwt = JsonWebTokenCodec();

class JsonWebTokenCodec extends Codec<JsonWebToken, String> {
  const JsonWebTokenCodec();

  @override
  JsonWebTokenDecoder get decoder => const JsonWebTokenDecoder();

  @override
  JsonWebTokenEncoder get encoder => const JsonWebTokenEncoder();
}

//

/// A decoder for Json Web Tokens.
class JsonWebTokenDecoder extends Converter<String, JsonWebToken> {
  const JsonWebTokenDecoder();

  @override
  JsonWebToken convert(String input) {
    final parts = input.split('.');
    if (parts.length != 3) {
      throw const FormatException('Input must have 3 parts.');
    }

    return JsonWebToken(
      header: decodeHeader(parts[0]),
      payload: decodePayload(parts[1]),
      signature: decodeSignature(parts[2]),
    );
  }

  Map<String, dynamic> decodeHeader(String input) {
    return json.decode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(input),
        ),
      ),
    );
  }

  Map<String, dynamic> decodePayload(String input) {
    return json.decode(
      utf8.decode(
        base64Url.decode(
          base64Url.normalize(input),
        ),
      ),
    );
  }

  Uint8List decodeSignature(String input) {
    return base64Url.decode(
      base64Url.normalize(input),
    );
  }
}

/// An encode for Json Web Tokens.
class JsonWebTokenEncoder extends Converter<JsonWebToken, String> {
  const JsonWebTokenEncoder();

  @override
  String convert(JsonWebToken input) {
    return [
      encodeHeader(input.header),
      encodePayload(input.payload),
      encodeSignature(input.signature),
    ].join('.');
  }

  String encodeHeader(Map<String, dynamic> input) {
    var jsonString = jsonEncode(input);
    final bytes = utf8.encode(jsonString);
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  String encodePayload(Map<String, dynamic> input) {
    // The json string might contain the single quote character which must be
    // replaced by the unicode value. If single quotes are not replaced the
    // JWT will not be valid.
    final jsonString = jsonEncode(input).replaceAll('\'', '\\u0027');
    final bytes = utf8.encode(jsonString);
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  String encodeSignature(Uint8List input) {
    return base64Url.encode(input).replaceAll('=', '');
  }
}
