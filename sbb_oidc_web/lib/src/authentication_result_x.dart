import 'package:msal_js/msal_js.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

extension AuthenticationResultX on AuthenticationResult {
  OidcToken get oidcToken {
    return OidcToken(
      tokenType: tokenType,
      accessToken: AccessToken(accessToken),
      accessTokenExpirationDateTime: expiresOn,
      idToken: JsonWebToken.decode(idToken),
    );
  }
}
