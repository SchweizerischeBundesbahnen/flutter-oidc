import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/sbb_oidc_api.g.dart',
    dartPackageName: 'sbb_oidc',
    kotlinOut: 'android/src/main/kotlin/ch/sbb/appbakery/oidc/SBBOidcApi.g.kt',
    kotlinOptions: KotlinOptions(
      package: 'ch.sbb.appbakery.oidc',
    ),
    swiftOut: 'ios/sbb_oidc/Sources/sbb_oidc/SBBOidcApi.g.swift',
  ),
)
class InitializeParameters {
  const InitializeParameters({
    required this.clientId,
    required this.keychainAccessGroup,
    required this.redirectUri,
    required this.tenantId,
  });

  final String clientId;
  final String keychainAccessGroup;
  final String redirectUri;
  final String tenantId;
}

class LoginParameters {
  const LoginParameters({
    this.loginHint,
    this.prompt,
    required this.scopes,
  });

  final String? loginHint;
  final String? prompt;
  final List<String> scopes;
}

class GetTokenParameters {
  const GetTokenParameters({
    required this.forceRefresh,
    required this.scopes,
  });

  final bool forceRefresh;
  final List<String> scopes;
}

class OidcTokenResponse {
  OidcTokenResponse({
    required this.accessToken,
    required this.authenticationScheme,
    this.expiresOn,
    this.idToken,
  });

  final String accessToken;
  final String authenticationScheme;
  final String? expiresOn;
  final String? idToken;
}

@HostApi()
abstract class SBBOidcHostApi {
  @async
  void initialize(InitializeParameters parameters);

  @async
  OidcTokenResponse login(LoginParameters parameters);

  @async
  OidcTokenResponse getToken(GetTokenParameters parameters);

  @async
  void logout();

  @async
  void endSession();
}
