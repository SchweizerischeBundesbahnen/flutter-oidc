import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

void main() {
  group('BLS', () {
    test('OIDC token 1', () async {
      final file = _file('bls_oidc_token_1.json');
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.accessToken.isJsonWebToken, true);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });

    test('OIDC token 2', () async {
      final file = _file('bls_oidc_token_2.json');
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.accessToken.isJsonWebToken, true);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });
  });

  group('Postauto', () {
    test('OIDC token 1', () async {
      final file = _file('postauto_oidc_token_1.json');
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.accessToken.isJsonWebToken, true);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });

    test('OIDC token 2', () async {
      final file = _file('postauto_oidc_token_2.json');
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.accessToken.isJsonWebToken, true);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });
  });
}

// Internal

File _file(String name, {String dir = 'test_data/oidc_token'}) {
  return File('$dir/$name');
}
