import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:sbb_oidc_example/auth/authenticator_config.dart';
import 'package:sbb_oidc_example/auth/token_spec.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';
import 'package:sbb_oidc_example/logging.dart';

typedef AuthenticatorConfigFactory = AuthenticatorConfig Function();

enum Flavor {
  exampleApp(
    authenticatorConfigFactory: _exampleAppAuthenticatorConfig,
    displayName: 'Example App',
    envFile: 'assets/example_app.env',
    logLevel: Level.ALL,
    logPrinter: LogPrinter(
      appName: 'SBB-OIDC-EXAMPLE',
    ),
  ),
  esqMobileDev(
    authenticatorConfigFactory: _esqMobileDevAuthenticatorConfig,
    displayName: 'ESQ Mobile Dev',
    envFile: 'assets/esq_mobile_dev.env',
    logLevel: Level.ALL,
    logPrinter: LogPrinter(
      appName: 'ESQ-DEV',
    ),
  );

  const Flavor({
    required this.authenticatorConfigFactory,
    required this.displayName,
    required this.envFile,
    required this.logLevel,
    required this.logPrinter,
  });

  final AuthenticatorConfigFactory authenticatorConfigFactory;
  final String displayName;
  final String envFile;
  final Level logLevel;
  final LogPrinter logPrinter;

  AuthenticatorConfig get authenticatorConfig {
    return authenticatorConfigFactory.call();
  }
}

// Authenticator config factory functions.

AuthenticatorConfig _exampleAppAuthenticatorConfig() {
  return AuthenticatorConfig(
    clientId: dotenv.env['CLIENT_ID']!,
    keychainAccessGroup: dotenv.env['KEYCHAIN_ACCESS_GROUP']!,
    redirectUrl: dotenv.env['REDIRECT_URL']!,
    tenantId: dotenv.env['TENANT_ID']!,
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
    clientId: dotenv.env['CLIENT_ID']!,
    keychainAccessGroup: dotenv.env['KEYCHAIN_ACCESS_GROUP']!,
    redirectUrl: dotenv.env['REDIRECT_URL']!,
    tenantId: dotenv.env['TENANT_ID']!,
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
