import 'package:msal_js/msal_js.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

extension AuthExceptionX on AuthException {
  bool get isLoginCanceled {
    return errorCode == 'user_cancelled';
  }

  Exception convert() {
    if (isLoginCanceled) {
      return LoginCanceledException(cause: this);
    }
    return this;
  }
}
