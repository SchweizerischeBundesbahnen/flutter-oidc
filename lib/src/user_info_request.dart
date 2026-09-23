import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

typedef AuthorizationProvider = Future<String> Function();

class UserInfoRequest {
  UserInfoRequest({
    required this._authorizationProvider,
    required this._httpClient,
    required this._userInfoEndpoint,
  });

  final AuthorizationProvider _authorizationProvider;
  final Client _httpClient;
  final String _userInfoEndpoint;

  Future<UserInfo> execute() async {
    final url = Uri.parse(_userInfoEndpoint);
    final authorization = await _authorizationProvider.call();
    final response = await _httpClient.get(
      url,
      headers: {'Authorization': authorization},
    );
    // Handle errors.
    if (response.statusCode != HttpStatus.ok) {
      throw HttpException(
        'HTTP ${response.statusCode}: Get user info failed.',
        uri: url,
      );
    }
    // UTF-8 decode the response body to prevent decoding errors. This might happen when the body
    // contains diacritics and the content type header does not specify an encoding.
    final jsonString = utf8.decode(response.bodyBytes);
    return UserInfo.fromJsonString(jsonString);
  }
}
