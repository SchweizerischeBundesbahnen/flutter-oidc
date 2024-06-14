import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

void main() {
  group('UserInfo.fromJsonString()', () {
    test('Jane Doe', () async {
      const file = 'jane_doe.json';
      final jsonString = await _readFile(file);
      final userInfo = UserInfo.fromJsonString(jsonString);
      expect(userInfo.sub, 'XYZ123ab45xy');
      expect(userInfo.name, null);
      expect(userInfo.familyName, null);
      expect(userInfo.givenName, null);
      expect(userInfo.picture, null);
      expect(userInfo.email, null);
    });

    test('John Doe', () async {
      const file = 'john_doe.json';
      final jsonString = await _readFile(file);
      final userInfo = UserInfo.fromJsonString(jsonString);
      expect(userInfo.sub, 'XYZ123ab45cd');
      expect(userInfo.name, 'John Doe');
      expect(userInfo.familyName, 'Doe');
      expect(userInfo.givenName, 'John');
      expect(userInfo.picture, 'https://sbb.ch/v1.0/me/photo/\$value');
      expect(userInfo.email, 'john.doe@sbb.ch');
    });

    test('Max O\'Neill', () async {
      const file = 'max_oneill.json';
      final jsonString = await _readFile(file);
      final userInfo = UserInfo.fromJsonString(jsonString);
      expect(userInfo.sub, 'XXX1234');
      expect(userInfo.name, 'Max O\'Neill');
      expect(userInfo.familyName, 'O\'Neill');
      expect(userInfo.givenName, 'Max');
      expect(userInfo.picture, 'https://sbb.ch/v1.0/me/photo/\$value');
      expect(userInfo.email, 'max.oneill@sbb.ch');
    });
  });
}

//

Future<String> _readFile(String name) {
  final file = File('test_data/user_info/$name');
  return file.readAsString();
}
