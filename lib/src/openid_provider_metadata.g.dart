// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'openid_provider_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OpenIDProviderMetadata _$OpenIDProviderMetadataFromJson(
        Map<String, dynamic> json) =>
    OpenIDProviderMetadata(
      authorizationEndpoint: json['authorization_endpoint'] as String,
      claimsSupported: (json['claims_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      cloudGraphHostName: json['cloud_graph_host_name'] as String,
      cloudInstanceName: json['cloud_instance_name'] as String,
      deviceAuthorizationEndpoint:
          json['device_authorization_endpoint'] as String,
      endSessionEndpoint: json['end_session_endpoint'] as String,
      frontchannelLogoutSupported:
          json['frontchannel_logout_supported'] as bool,
      httpLogoutSupported: json['http_logout_supported'] as bool,
      idTokenSigningAlgValuesSupported:
          (json['id_token_signing_alg_values_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      issuer: json['issuer'] as String,
      jwksUri: json['jwks_uri'] as String,
      kerberosEndpoint: json['kerberos_endpoint'] as String,
      msgraphHost: json['msgraph_host'] as String,
      rbacUrl: json['rbac_url'] as String,
      requestUriParameterSupported:
          json['request_uri_parameter_supported'] as bool,
      responseModesSupported:
          (json['response_modes_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      responseTypesSupported:
          (json['response_types_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      scopesSupported: (json['scopes_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      subjectTypesSupported: (json['subject_types_supported'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tenantRegionScope: json['tenant_region_scope'] as String?,
      tokenEndpoint: json['token_endpoint'] as String,
      tokenEndpointAuthMethodsSupported:
          (json['token_endpoint_auth_methods_supported'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
      userinfoEndpoint: json['userinfo_endpoint'] as String,
    );

Map<String, dynamic> _$OpenIDProviderMetadataToJson(
        OpenIDProviderMetadata instance) =>
    <String, dynamic>{
      'authorization_endpoint': instance.authorizationEndpoint,
      'claims_supported': instance.claimsSupported,
      'cloud_graph_host_name': instance.cloudGraphHostName,
      'cloud_instance_name': instance.cloudInstanceName,
      'device_authorization_endpoint': instance.deviceAuthorizationEndpoint,
      'end_session_endpoint': instance.endSessionEndpoint,
      'frontchannel_logout_supported': instance.frontchannelLogoutSupported,
      'http_logout_supported': instance.httpLogoutSupported,
      'id_token_signing_alg_values_supported':
          instance.idTokenSigningAlgValuesSupported,
      'issuer': instance.issuer,
      'jwks_uri': instance.jwksUri,
      'kerberos_endpoint': instance.kerberosEndpoint,
      'msgraph_host': instance.msgraphHost,
      'rbac_url': instance.rbacUrl,
      'request_uri_parameter_supported': instance.requestUriParameterSupported,
      'response_modes_supported': instance.responseModesSupported,
      'response_types_supported': instance.responseTypesSupported,
      'scopes_supported': instance.scopesSupported,
      'subject_types_supported': instance.subjectTypesSupported,
      'tenant_region_scope': instance.tenantRegionScope,
      'token_endpoint': instance.tokenEndpoint,
      'token_endpoint_auth_methods_supported':
          instance.tokenEndpointAuthMethodsSupported,
      'userinfo_endpoint': instance.userinfoEndpoint,
    };
