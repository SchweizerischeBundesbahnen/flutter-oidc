import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc/src/appauth/app_auth_oidc_client.dart';
import 'package:sbb_oidc/src/token_store.dart';

@GenerateNiceMocks([
  MockSpec<Client>(),
  MockSpec<OidcToken>(),
  MockSpec<OpenIDProviderMetadata>(),
  MockSpec<TokenStore>(),
])
import 'app_auth_oidc_client_test.mocks.dart';

const _kUserInfoUrl = 'https://user.info';

void main() {
  test('getUserInfo() - François Müller', () async {
    const userInfo = UserInfo(
      sub: 'u0123456789',
      name: 'Müller François (XX-ABC-123)',
      familyName: 'Müller',
      givenName: 'François',
      email: 'francois.mueller@sbb.ch',
    );

    final httpClient = MockClient();
    when(
      httpClient.get(
        Uri.parse(_kUserInfoUrl),
        headers: anyNamed('headers'),
      ),
    ).thenAnswer(
      (_) async {
        return Response.bytes(
          utf8.encode(userInfo.toJsonString()),
          200,
          headers: {
            'Content-Type': 'application/json',
          },
        );
      },
    );

    final oidcClient = AppAuthOidcClient(
      clientId: 'clientId_12345',
      httpClient: httpClient,
      postLogoutRedirectUrl: null,
      providerConfiguration: _mockProviderConfiguration(),
      redirectUrl: 'sbb_oidc://test/redirect',
      tokenStore: _mockTokenStore(),
    );

    final userInfo2 = await oidcClient.getUserInfo(scopes: ['user.read']);
    expect(userInfo2, userInfo);
  });
}

OpenIDProviderMetadata _mockProviderConfiguration() {
  final providerConfiguration = MockOpenIDProviderMetadata();
  when(providerConfiguration.userinfoEndpoint).thenReturn(_kUserInfoUrl);
  return providerConfiguration;
}

TokenStore _mockTokenStore() {
  final oidcToken = MockOidcToken();
  when(oidcToken.tokenType).thenReturn('Bearer');
  when(oidcToken.accessToken).thenReturn('mock_access_token');
  when(oidcToken.idToken).thenReturn('mock_id_token');
  when(oidcToken.refreshToken).thenReturn('mock_refresh_token');
  when(oidcToken.isExpired).thenReturn(false);
  final tokenStore = MockTokenStore();
  when(tokenStore.read(any)).thenAnswer((_) async => oidcToken);
  return tokenStore;
}
