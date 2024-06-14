import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sbb_oidc_platform_interface/src/oidc_service.dart';
import 'package:sbb_oidc_platform_interface/src/types/openid_provider_metadata.dart';

export 'package:sbb_oidc_platform_interface/src/exceptions/login_canceled_exception.dart';
export 'package:sbb_oidc_platform_interface/src/exceptions/multi_factor_authentication_exception.dart';
export 'package:sbb_oidc_platform_interface/src/exceptions/network_exception.dart';
export 'package:sbb_oidc_platform_interface/src/exceptions/oidc_exception.dart';
export 'package:sbb_oidc_platform_interface/src/exceptions/refresh_token_expired_exception.dart';
export 'package:sbb_oidc_platform_interface/src/oidc_service.dart';
export 'package:sbb_oidc_platform_interface/src/types/access_token.dart';
export 'package:sbb_oidc_platform_interface/src/types/jwt/json_web_token.dart';
export 'package:sbb_oidc_platform_interface/src/types/login_prompt.dart';
export 'package:sbb_oidc_platform_interface/src/types/oidc_token.dart';
export 'package:sbb_oidc_platform_interface/src/types/openid_provider_metadata.dart';
export 'package:sbb_oidc_platform_interface/src/types/user_info.dart';

/// The interface that platform specific implementations must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `sbb_oidc` does not consider newly added methods to be breaking changes.
/// Extending this class (using `extends`) ensures that the subclass will get
/// the default implementation, while platform implementations that
/// `implements` this interface will be broken by newly added [SBBOidcPlatform]
/// methods.
abstract class SBBOidcPlatform extends PlatformInterface {
  /// Constructs a SBBOidcPlatform.
  SBBOidcPlatform() : super(token: _token);

  static final Object _token = Object();

  static late SBBOidcPlatform _instance;

  /// The default instance of [SBBOidcPlatform] to use.
  static SBBOidcPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SBBOidcPlatform] when they register themselves.
  static set instance(SBBOidcPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the platform-specific implementation of the OpenID Connect
  /// service.
  OidcService oidcService({
    required OpenIDProviderMetadata providerConfiguration,
    required String clientId,
    required String redirectUrl,
    String? postLogoutRedirectUrl,
  }) {
    throw UnimplementedError();
  }
}
