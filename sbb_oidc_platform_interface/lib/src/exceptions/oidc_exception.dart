class OidcException implements Exception {
  const OidcException({
    this.message = 'Unspecified oidc exception.',
    this.cause,
  });

  /// A message describing the oidc exception.
  final String message;

  /// The root cause of the oidc exception.
  final dynamic cause;
}
