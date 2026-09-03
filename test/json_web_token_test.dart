import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

// This files used by this test are not pushed to git for security and data protection reasons.
void main() {
  group('BLS', () {
    // Scopes: openid, profile, email, offline_access, User.Read
    test('Access token 1', () async {
      final file = await _file('bls_access_token_1.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, <API-Scope>
    test('Access token 2', () async {
      final file = await _file('bls_access_token_2.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, User.Read
    test('ID token 1', () async {
      final file = await _file('bls_id_token_1.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, <API-Scope>
    test('ID token 2', () async {
      final file = await _file('bls_id_token_2.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });
  });

  group('Postauto', () {
    // Scopes: openid, profile, email, offline_access, User.Read
    test('Access token 1', () async {
      final file = await _file('postauto_access_token_1.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, <API-Scope>
    test('Access token 2', () async {
      final file = await _file('postauto_access_token_2.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, User.Read
    test('ID token 1', () async {
      final file = await _file('postauto_id_token_1.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });

    // Scopes: openid, profile, email, offline_access, <API-Scope>
    test('ID token 2', () async {
      final file = await _file('postauto_id_token_2.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
    });
  });

  group('SBB', () {
    // The name of the user contains a ' character which must be handled
    // specifically.
    test('Access token 1', () async {
      final file = await _file('sbb_access_token_1.txt');
      if (file == null) {
        return;
      }
      final jwtString = await file.readAsString();
      final jwt = JsonWebToken.decode(jwtString);
      expect(jwt.payload, isNotEmpty);
      expect(jwt.payload['family_name'], 'D\'Mobile');
      expect(jwt.payload['name'], 'D\'Mobile (IT-PTR-CEN1-BDE4)');
      final jwtString2 = jwt.encode();
      expect(jwtString2, jwtString);
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
