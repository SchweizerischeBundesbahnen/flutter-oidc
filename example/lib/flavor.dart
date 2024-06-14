import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sbb_oidc_example/auth/authenticator_config.dart';
import 'package:sbb_oidc_example/auth/token_spec.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';

enum Flavor {
  mobile(
    displayName: 'Mobile',
  ),
  web(
    displayName: 'Web',
  );

  const Flavor({
    required this.displayName,
  });

  final String displayName;

  AuthenticatorConfig get authenticatorConfig {
    return AuthenticatorConfig(
      discoveryUrl: dotenv.env['DISCOVERY_URL']!,
      clientId: dotenv.env['CLIENT_ID']!,
      redirectUrl: switch (this) {
        mobile => dotenv.env['MOBILE_REDIRECT_URL']!,
        web => dotenv.env['WEB_REDIRECT_URL']!,
      },
      tokenSpecs: TokenSpecProvider([
        TokenSpec(
          id: 'T1',
          displayName: 'Token 1',
          scopes: dotenv.env['SCOPES']!.split(','),
        ),
      ]),
    );
  }
}
