import 'package:get_it/get_it.dart';
import 'package:logging/logging.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/auth/authenticator_impl.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';
import 'package:sbb_oidc_example/flavor.dart';

final _log = Logger('DI');

class DI {
  const DI._();

  static Future<void> initialize(Flavor flavor) {
    _log.info('Initialize dependency injection');
    return GetIt.I.init(flavor);
  }

  static T get<T extends Object>({
    String? instanceName,
    dynamic param1,
    dynamic param2,
  }) {
    return GetIt.I.get(
      instanceName: instanceName,
      param1: param1,
      param2: param2,
    );
  }
}

// Internal

extension _GetItX on GetIt {
  Future<void> init(Flavor flavor) async {
    _registerFlavor(flavor);
    _registerTokenSpecProvider();
    _registerOidcClient();
    _registerAuthenticator();
    await allReady();
  }

  void _registerFlavor(Flavor flavor) {
    registerSingleton<Flavor>(flavor);
  }

  void _registerTokenSpecProvider() {
    factoryFunc() {
      final flavor = get<Flavor>();
      return flavor.authenticatorConfig.tokenSpecs;
    }

    registerSingleton<TokenSpecProvider>(factoryFunc());
  }

  void _registerOidcClient() {
    factoryFunc() {
      final flavor = get<Flavor>();
      final authenticatorConfig = flavor.authenticatorConfig;
      return SBBOpenIDConnect.createClient(
        config: OidcClientConfig(
          tenantId: SBBTenant.prod.id,
          clientId: authenticatorConfig.clientId,
          redirectUrl: authenticatorConfig.redirectUrl,
          keychainAccessGroup: authenticatorConfig.keychainAccessGroup,
        ),
      );
    }

    registerSingletonAsync<OidcClient>(factoryFunc);
  }

  void _registerAuthenticator() {
    factoryFunc() {
      return AuthenticatorImpl(
        oidcClient: get(),
        tokenSpecs: get(),
      );
    }

    registerSingletonWithDependencies<Authenticator>(
      factoryFunc,
      dependsOn: [OidcClient],
    );
  }
}
