import 'package:msal_js/msal_js.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

class PublicClientApplicationFactory {
  const PublicClientApplicationFactory._();

  static PublicClientApplication create({
    required OpenIDProviderMetadata providerConfiguration,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
  }) {
    final auth = BrowserAuthOptions();
    auth.authorityMetadata = providerConfiguration.toJsonString();
    auth.knownAuthorities = [providerConfiguration.issuer];
    auth.clientId = clientId;
    auth.redirectUri = redirectUrl;
    auth.postLogoutRedirectUri = postLogoutRedirectUrl;

    final cache = CacheOptions();
    cache.cacheLocation = BrowserCacheLocation.localStorage;

    final logger = LoggerOptions();
    logger.loggerCallback = _log;
    logger.logLevel = LogLevel.error;

    final system = BrowserSystemOptions();
    system.loggerOptions = logger;

    final configuration = Configuration();
    configuration.auth = auth;
    configuration.cache = cache;
    configuration.system = system;

    return PublicClientApplication(configuration);
  }
}

void _log(LogLevel level, String message, bool containsPii) {
  // Log nothing
}
