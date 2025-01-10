import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sbb_oidc_example/auth/authenticator_config.dart';
import 'package:sbb_oidc_example/auth/token_spec.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';

typedef AuthenticatorConfigFactory = AuthenticatorConfig Function();

enum Flavor {
  exampleApp(
    displayName: 'Example App',
    envFile: 'assets/example_app.env',
    authenticatorConfigFactory: _exampleAppAuthenticatorConfig,
  ),
  esqMobileDev(
    displayName: 'ESQ Mobile Dev',
    envFile: 'assets/esq_mobile_dev.env',
    authenticatorConfigFactory: _esqMobileDevAuthenticatorConfig,
  );

  const Flavor({
    required this.displayName,
    required this.envFile,
    required this.authenticatorConfigFactory,
  });

  final String displayName;
  final String envFile;
  final AuthenticatorConfigFactory authenticatorConfigFactory;

  AuthenticatorConfig get authenticatorConfig {
    return authenticatorConfigFactory.call();
  }
}

// Authenticator config factory functions.

AuthenticatorConfig _exampleAppAuthenticatorConfig() {
  return AuthenticatorConfig(
    discoveryUrl: dotenv.env['DISCOVERY_URL']!,
    clientId: dotenv.env['CLIENT_ID']!,
    redirectUrl: dotenv.env['REDIRECT_URL']!,
    tokenSpecs: TokenSpecProvider([
      TokenSpec(
        id: 'T1',
        displayName: 'Token 1',
        scopes: dotenv.env['SCOPES']!.split(','),
      ),
    ]),
  );
}

AuthenticatorConfig _esqMobileDevAuthenticatorConfig() {
  return AuthenticatorConfig(
    discoveryUrl: dotenv.env['DISCOVERY_URL']!,
    clientId: dotenv.env['CLIENT_ID']!,
    redirectUrl: dotenv.env['REDIRECT_URL']!,
    tokenSpecs: TokenSpecProvider([
      TokenSpec(
        id: 'T0',
        displayName: 'Default',
        scopes: dotenv.env['SCOPES_0']!.split(','),
      ),
      TokenSpec(
        id: 'T1',
        displayName: 'API 1',
        scopes: dotenv.env['SCOPES_1']!.split(','),
      ),
      TokenSpec(
        id: 'T2',
        displayName: 'API 2',
        scopes: dotenv.env['SCOPES_2']!.split(','),
      ),
    ]),
  );
}
