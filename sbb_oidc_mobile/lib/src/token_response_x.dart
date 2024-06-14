// Extensions

import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

extension TokenResponseX on TokenResponse {
  OidcToken get oidcToken {
    return OidcToken(
      tokenType: tokenType!,
      accessToken: AccessToken(accessToken!),
      accessTokenExpirationDateTime: accessTokenExpirationDateTime,
      refreshToken: refreshToken,
      idToken: JsonWebToken.decode(idToken!),
    );
  }
}
