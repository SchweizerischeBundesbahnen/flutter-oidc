import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

class TokenStore {
  const TokenStore();

  final _storage = const FlutterSecureStorage();

  Future<OidcToken?> read(String key) async {
    final jsonString = await _storage.read(key: key);
    if (jsonString == null) {
      return null;
    }
    return OidcToken.fromJsonString(jsonString);
  }

  Future<Map<String, OidcToken>> readAll() async {
    final data = await _storage.readAll();
    final tokens = <String, OidcToken>{};
    for (var entry in data.entries) {
      try {
        tokens[entry.key] = OidcToken.fromJsonString(entry.value);
      } catch (e) {
        // Ignore because the storage can contain things that are not an oidc
        // token.
      }
    }
    return tokens;
  }

  Future<void> write(String key, OidcToken oidcToken) {
    final jsonString = oidcToken.toJsonString();
    return _storage.write(key: key, value: jsonString);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }

  Future<void> deleteAll() {
    return _storage.deleteAll();
  }
}
