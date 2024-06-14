import 'package:flutter/services.dart';
import 'package:sbb_oidc_platform_interface/sbb_oidc_platform_interface.dart';

extension PlatformExceptionX on PlatformException {
  bool get isLoginCanceled {
    return _messageContains([
      'User cancelled flow',
      'The user has denied access',
      'general error -3',
    ]);
  }

  bool get isMultiFactorAuthenticationError {
    return _messageContains([
      'you must use multi-factor authentication to access',
      'you must refresh your multi-factor authentication to access',
    ]);
  }

  bool get isNetworkError {
    return _messageContains([
      'Network error',
      'general error -5',
    ]);
  }

  bool get isRefreshTokenExpiredError {
    return _messageContains([
      'AADSTS700082',
      'AADSTS70008',
      'error?code=700082',
      'refresh token has expired',
    ]);
  }

  bool _messageContains(List<String> elements) {
    if (elements.isEmpty) {
      return false;
    }

    final message = this.message;
    if (message == null) {
      return false;
    }

    for (final element in elements) {
      if (message.contains(element)) {
        return true;
      }
    }

    return false;
  }

  Exception convert() {
    if (isLoginCanceled) {
      return LoginCanceledException(cause: this);
    } else if (isMultiFactorAuthenticationError) {
      return MultiFactorAuthenticationException(cause: this);
    } else if (isNetworkError) {
      return NetworkException(cause: this);
    } else if (isRefreshTokenExpiredError) {
      return RefreshTokenExpiredException(cause: this);
    }
    return this;
  }
}
