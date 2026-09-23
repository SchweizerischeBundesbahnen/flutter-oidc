import 'package:flutter/services.dart';
import 'package:sbb_oidc/sbb_oidc.dart';

extension PlatformExceptionX on PlatformException {
  Exception convert() {
    // Keep the alphabetical order
    return _invalidConfig() ??
        _invalidRefreshToken() ??
        _invalidScope() ??
        _loginCanceled() ??
        _multiFactorAuthenticationRequired() ??
        _noNetwork() ??
        _noSession() ??
        _requestTimeout() ??
        OidcException(
          code: 'unknown',
          message: '$code : $message',
          details: details,
        );
  }

  InvalidConfigException? _invalidConfig() {
    final match =
        code.contains('invalid_parameter') ||
        code.contains('malformed_url') ||
        code.contains('unknown_authority') ||
        code.contains('redirect_uri_validation_error') ||
        code.contains('app_manifest_validation_error');
    return match ? InvalidConfigException(details: this) : null;
  }

  InvalidGrantException? _invalidRefreshToken() {
    final match =
        code.contains('invalid_grant') ||
        _messageContains([
          'AADSTS50085',
          'AADSTS50089',
          'AADSTS50132',
          'AADSTS50133',
          'AADSTS50139',
          'AADSTS50143',
          'AADSTS70008',
          'AADSTS700082',
          'AADSTS700084',
          'AADSTS70043',
          'error?code=700082',
          'refresh token has expired',
        ]);
    return match ? InvalidGrantException(details: this) : null;
  }

  InvalidScopeException? _invalidScope() {
    final match =
        code.contains('invalid_scope') ||
        _messageContains([
          'AADSTS70011',
          'AADSTS28002',
          'AADSTS28003',
          'AADSTS700022',
          'AADSTS700023',
        ]);
    return match ? InvalidScopeException(details: this) : null;
  }

  LoginCanceledException? _loginCanceled() {
    final match =
        code.contains('login_canceled') ||
        code.contains('user_cancelled') ||
        _messageContains([
          'User cancelled flow',
          'The user has denied access',
          'general error -3',
        ]);
    return match ? LoginCanceledException(details: this) : null;
  }

  MultiFactorAuthenticationException? _multiFactorAuthenticationRequired() {
    final match =
        code.contains('mfa_required') ||
        code.contains('additional_action') ||
        _messageContains([
          'AADSTS50072',
          'AADSTS50074',
          'AADSTS50076',
          'AADSTS50078',
          'AADSTS50079',
          'AADSTS50158',
          'AADSTS53004',
          'AADSTS90072',
          'you must use multi-factor authentication to access',
          'you must refresh your multi-factor authentication to access',
        ]);
    return match ? MultiFactorAuthenticationException(message: message, details: this) : null;
  }

  NoNetworkException? _noNetwork() {
    final match =
        code.contains('device_network_not_available') ||
        _messageContains([
          'Network error',
          'general error -5',
        ]);
    return match ? NoNetworkException(details: this) : null;
  }

  NoSessionException? _noSession() {
    final match =
        code.contains('no_tokens_found') ||
        code.contains('no_account_found') ||
        code.contains('no_current_account') ||
        code.contains('login_required') ||
        code.contains('interaction_required') ||
        _messageContains([
          'AADSTS50058',
          'AADSTS700020',
        ]);
    return match ? NoSessionException(details: this) : null;
  }

  RequestTimeoutException? _requestTimeout() {
    final match = code.contains('request_timeout');
    return match ? RequestTimeoutException(details: this) : null;
  }

  bool _messageContains(List<String> elements) {
    if (elements.isEmpty) {
      return false;
    }
    final message = this.message?.toLowerCase();
    if (message == null) {
      return false;
    }
    for (var element in elements) {
      element = element.toLowerCase();
      if (message.contains(element)) {
        return true;
      }
    }
    return false;
  }
}
