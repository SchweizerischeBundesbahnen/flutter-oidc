import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'oidc_client_config.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
@sealed
@immutable
class OidcClientConfig {
  const OidcClientConfig({
    required this.tenantId,
    required this.clientId,
    required this.redirectUrl,
    required this.keychainAccessGroup,
  });

  /// Creates an OIDC client configuration from a JSON string.
  factory OidcClientConfig.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return OidcClientConfig.fromJson(json);
  }

  /// Creates an OIDC client configuration from JSON.
  factory OidcClientConfig.fromJson(Map<String, dynamic> json) {
    return _$OidcClientConfigFromJson(json);
  }

  /// The unique tenant ID of the organisation.
  final String tenantId;

  /// The registered client identifier.
  final String clientId;

  /// The URL to which the server redirects after authentication.
  final String redirectUrl;

  ///The iOS keychain access group used to cache tokens.
  ///
  /// Apps sharing the same group get silent SSO between them. Pass the app's bundle identifier
  /// to keep tokens private.
  ///
  /// The value must also be declared in the app's keychain access groups entitlement.
  ///
  /// For more information, see:
  /// https://developer.apple.com/documentation/security/sharing-access-to-keychain-items-among-a-collection-of-apps?language=objc
  final String keychainAccessGroup;

  /// Converts this OIDC client configuration to JSON.
  Map<String, dynamic> toJson() {
    return _$OidcClientConfigToJson(this);
  }

  /// Converts this OIDC client configuration to a JSON string.
  String toJsonString({bool pretty = false}) {
    final encoder = JsonEncoder.withIndent(pretty ? ' ' * 2 : null);
    final json = toJson();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is OidcClientConfig &&
        other.clientId == clientId &&
        other.keychainAccessGroup == keychainAccessGroup &&
        other.redirectUrl == redirectUrl &&
        other.tenantId == tenantId;
  }

  @override
  int get hashCode {
    return Object.hash(
      clientId,
      keychainAccessGroup,
      redirectUrl,
      tenantId,
    );
  }

  @override
  String toString() {
    final fields = [
      'tenantId: $tenantId',
      'clientId: $clientId',
      'redirectUrl: $redirectUrl',
      'keychainAccessGroup: $keychainAccessGroup',
    ];
    return 'OidcClientConfig(${fields.join(', ')})';
  }
}
