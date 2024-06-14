import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

void main() {
  group('OpenIDProviderMetadata.fromJsonString()', () {
    test('BLS', () async {
      const file = 'bls.json';
      final jsonString = await _readFile(file);
      OpenIDProviderMetadata.fromJsonString(jsonString);
    });

    test('Microsoft Common', () async {
      const file = 'microsoft_common.json';
      final jsonString = await _readFile(file);
      OpenIDProviderMetadata.fromJsonString(jsonString);
    });

    test('SBB Dev', () async {
      const file = 'sbb_dev.json';
      final jsonString = await _readFile(file);
      OpenIDProviderMetadata.fromJsonString(jsonString);
    });

    test('SBB Prod', () async {
      const file = 'sbb_prod.json';
      final jsonString = await _readFile(file);
      OpenIDProviderMetadata.fromJsonString(jsonString);
    });
  });
}

//

Future<String> _readFile(String name) {
  final file = File('test_data/openid_provider_configuration/$name');
  return file.readAsString();
}
