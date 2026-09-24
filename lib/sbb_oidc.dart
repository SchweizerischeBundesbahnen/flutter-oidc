library;

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sbb_oidc/src/oidc_client.dart';
import 'package:sbb_oidc/src/oidc_client_config.dart';
import 'package:sbb_oidc/src/oidc_client_impl.dart';
import 'package:sbb_oidc/src/platform_exception_x.dart';
import 'package:sbb_oidc/src/sbb_oidc_api.g.dart';

export 'package:sbb_oidc/src/json_web_token.dart';
export 'package:sbb_oidc/src/login_prompt.dart';
export 'package:sbb_oidc/src/oidc_client.dart';
export 'package:sbb_oidc/src/oidc_client_config.dart';
export 'package:sbb_oidc/src/oidc_exception.dart';
export 'package:sbb_oidc/src/oidc_token.dart';
export 'package:sbb_oidc/src/sbb_tenant.dart';
export 'package:sbb_oidc/src/user_info.dart';

class SBBOpenIDConnect {
  const SBBOpenIDConnect._();

  /// Creates and configures an OIDC client ready for authentication operations.
  static Future<OidcClient> createClient({
    required OidcClientConfig config,
    bool enableLogging = false,
  }) async {
    final log = enableLogging ? Logger('SBB OIDC') : null;
    try {
      final client = OidcClientImpl(
        config: config,
        hostApi: SBBOidcHostApi(),
        log: enableLogging ? Logger('SBB OIDC') : null,
      );
      await client.initialize();
      return client;
    } catch (e, s) {
      log?.severe('Creating ODC client failed', e, s);
      if (e is PlatformException) {
        throw e.convert();
      } else {
        rethrow;
      }
    }
  }
}
