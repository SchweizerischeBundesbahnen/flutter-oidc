// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'oidc_client_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OidcClientConfig _$OidcClientConfigFromJson(Map<String, dynamic> json) =>
    OidcClientConfig(
      tenantId: json['tenant_id'] as String,
      clientId: json['client_id'] as String,
      redirectUrl: json['redirect_url'] as String,
      keychainAccessGroup: json['keychain_access_group'] as String,
    );

Map<String, dynamic> _$OidcClientConfigToJson(OidcClientConfig instance) =>
    <String, dynamic>{
      'tenant_id': instance.tenantId,
      'client_id': instance.clientId,
      'redirect_url': instance.redirectUrl,
      'keychain_access_group': instance.keychainAccessGroup,
    };
