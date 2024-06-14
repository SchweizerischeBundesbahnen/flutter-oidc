import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc/src/oidc_client_impl.dart';

// Annotation which generates the cat.mocks.dart library and the MockCat class.
@GenerateNiceMocks([
  MockSpec<AccessToken>(),
  MockSpec<Client>(),
  MockSpec<OidcService>(),
  MockSpec<OidcToken>(),
  MockSpec<OpenIDProviderMetadata>(),
])
import 'oidc_client_impl_test.mocks.dart';

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
    when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
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

    final oidcClient = OidcClientImpl(
      httpClient: httpClient,
      oidcService: _mockOidcService(),
      providerConfiguration: _mockProviderConfiguration(),
    );

    final userInfo2 = await oidcClient.getUserInfo(scopes: ['user.read']);
    expect(userInfo2, userInfo);
  });
}

OidcService _mockOidcService() {
  final accessToken = MockAccessToken();
  when(accessToken.value).thenReturn('mock_access_token');
  final oidcToken = MockOidcToken();
  when(oidcToken.accessToken).thenReturn(accessToken);
  when(oidcToken.tokenType).thenReturn('Bearer');
  final oidcService = MockOidcService();
  when(oidcService.getToken(any, any)).thenAnswer((_) async => oidcToken);
  return oidcService;
}

OpenIDProviderMetadata _mockProviderConfiguration() {
  final providerConfiguration = MockOpenIDProviderMetadata();
  when(providerConfiguration.userinfoEndpoint).thenReturn('https://user.info');
  return providerConfiguration;
}
