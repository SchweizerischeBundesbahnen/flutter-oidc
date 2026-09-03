import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

// This files used by this test are not pushed to git for security and data protection reasons.
void main() {
  group('BLS', () {
    test('OIDC token 1', () async {
      final file = await _file('bls_oidc_token_1.json');
      if (file == null) {
        return;
      }
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });

    test('OIDC token 2', () async {
      final file = await _file('bls_oidc_token_2.json');
      if (file == null) {
        return;
      }
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });
  });

  group('Postauto', () {
    test('OIDC token 1', () async {
      final file = await _file('postauto_oidc_token_1.json');
      if (file == null) {
        return;
      }
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });

    test('OIDC token 2', () async {
      final file = await _file('postauto_oidc_token_2.json');
      if (file == null) {
        return;
      }
      final jsonString = await file.readAsString();
      final token = OidcToken.fromJsonString(jsonString);
      expect(token, isNotNull);
      expect(token.tokenType, 'Bearer');
      expect(token.accessToken, isNotNull);
      expect(token.idToken, isNotNull);
      expect(token.refreshToken, isNotNull);
      expect(token.isExpired, true);
    });
  });
}

Future<File?> _file(String name, {String dir = 'test_data/jwt'}) async {
  final file = File('$dir/$name');
  final exists = await file.exists();
  if (exists) {
    return file;
  } else {
    return null;
  }
}
