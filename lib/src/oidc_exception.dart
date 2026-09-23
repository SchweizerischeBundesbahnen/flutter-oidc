class OidcException({
  required final String code,
  final String? message,
  final dynamic details,
}) implements Exception {}

// Specific exceptions

class InvalidConfigException({
  super.code = 'invalid_config',
  super.message = 'Bad OIDC client configuration',
  super.details,
}) extends OidcException {}

class InvalidGrantException({
  super.code = 'invalid_grant',
  super.message = 'The authentication grant is invalid, expired or revoked',
  super.details,
}) extends OidcException {}

class InvalidScopeException({
  super.code = 'invalid_scope',
  super.message = 'Requested scope is invalid or unknown',
  super.details,
}) extends OidcException {}

class LoginCanceledException({
  super.code = 'login_canceled',
  super.message = 'Login was canceled by the user',
  super.details,
}) extends OidcException {}

class MultiFactorAuthenticationException({
  super.code = 'multi_factor_authentication_required',
  super.message,
  super.details,
}) extends OidcException {}

class NoNetworkException({
  super.code = 'no_network',
  super.message = 'The device has no network connection',
  super.details,
}) extends OidcException {}

class NoSessionException({
  super.code = 'no_session',
  super.message = 'No valid session found → interactive login is required',
  super.details,
}) extends OidcException {}

class RequestTimeoutException({
  super.code = 'request_timeout',
  super.message,
  super.details,
}) extends OidcException {}
