import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'openid_provider_metadata.g.dart';

/// https://openid.net/specs/openid-connect-discovery-1_0.html#ProviderMetadata
@JsonSerializable(
  fieldRename: FieldRename.snake,
  explicitToJson: true,
)
@sealed
@immutable
class OpenIDProviderMetadata {
  const OpenIDProviderMetadata({
    required this.authorizationEndpoint,
    required this.claimsSupported,
    required this.cloudGraphHostName,
    required this.cloudInstanceName,
    required this.deviceAuthorizationEndpoint,
    required this.endSessionEndpoint,
    required this.frontchannelLogoutSupported,
    required this.httpLogoutSupported,
    required this.idTokenSigningAlgValuesSupported,
    required this.issuer,
    required this.jwksUri,
    required this.kerberosEndpoint,
    required this.msgraphHost,
    required this.rbacUrl,
    required this.requestUriParameterSupported,
    required this.responseModesSupported,
    required this.responseTypesSupported,
    required this.scopesSupported,
    required this.subjectTypesSupported,
    required this.tenantRegionScope,
    required this.tokenEndpoint,
    required this.tokenEndpointAuthMethodsSupported,
    required this.userinfoEndpoint,
  });

  factory OpenIDProviderMetadata.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return OpenIDProviderMetadata.fromJson(json);
  }

  factory OpenIDProviderMetadata.fromJson(Map<String, dynamic> json) {
    return _$OpenIDProviderMetadataFromJson(json);
  }

  final String authorizationEndpoint;
  final List<String> claimsSupported;
  final String cloudGraphHostName;
  final String cloudInstanceName;
  final String deviceAuthorizationEndpoint;
  final String endSessionEndpoint;
  final bool frontchannelLogoutSupported;
  final bool httpLogoutSupported;
  final List<String> idTokenSigningAlgValuesSupported;
  final String issuer;
  final String jwksUri;
  final String kerberosEndpoint;
  final String msgraphHost;
  final String rbacUrl;
  final bool requestUriParameterSupported;
  final List<String> responseModesSupported;
  final List<String> responseTypesSupported;
  final List<String> scopesSupported;
  final List<String> subjectTypesSupported;
  final String? tenantRegionScope;
  final String tokenEndpoint;
  final List<String> tokenEndpointAuthMethodsSupported;
  final String userinfoEndpoint;

  /// Converts this OpenID provider metadata to json.
  Map<String, dynamic> toJson() {
    return _$OpenIDProviderMetadataToJson(this);
  }

  /// Converts this OpenID provider metadata to a json string.
  String toJsonString({bool pretty = false}) {
    final encoder = JsonEncoder.withIndent(pretty ? ' ' * 2 : null);
    final json = toJson();
    return encoder.convert(json);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    const listEquality = ListEquality();
    return other is OpenIDProviderMetadata &&
        authorizationEndpoint == other.authorizationEndpoint &&
        listEquality.equals(claimsSupported, other.claimsSupported) &&
        cloudGraphHostName == other.cloudGraphHostName &&
        cloudInstanceName == other.cloudInstanceName &&
        deviceAuthorizationEndpoint == other.deviceAuthorizationEndpoint &&
        endSessionEndpoint == other.endSessionEndpoint &&
        frontchannelLogoutSupported == other.frontchannelLogoutSupported &&
        httpLogoutSupported == other.httpLogoutSupported &&
        listEquality.equals(
          idTokenSigningAlgValuesSupported,
          other.idTokenSigningAlgValuesSupported,
        ) &&
        issuer == other.issuer &&
        jwksUri == other.jwksUri &&
        kerberosEndpoint == other.kerberosEndpoint &&
        msgraphHost == other.msgraphHost &&
        rbacUrl == other.rbacUrl &&
        requestUriParameterSupported == other.requestUriParameterSupported &&
        listEquality.equals(
          responseModesSupported,
          other.responseModesSupported,
        ) &&
        listEquality.equals(
          responseTypesSupported,
          other.responseTypesSupported,
        ) &&
        listEquality.equals(scopesSupported, other.scopesSupported) &&
        listEquality.equals(
          subjectTypesSupported,
          other.subjectTypesSupported,
        ) &&
        tenantRegionScope == other.tenantRegionScope &&
        tokenEndpoint == other.tokenEndpoint &&
        listEquality.equals(
          tokenEndpointAuthMethodsSupported,
          other.tokenEndpointAuthMethodsSupported,
        ) &&
        userinfoEndpoint == other.userinfoEndpoint;
  }

  @override
  int get hashCode {
    const listEquality = ListEquality();
    return Object.hashAll([
      authorizationEndpoint,
      listEquality.hash(claimsSupported),
      cloudGraphHostName,
      cloudInstanceName,
      deviceAuthorizationEndpoint,
      endSessionEndpoint,
      frontchannelLogoutSupported,
      httpLogoutSupported,
      listEquality.hash(idTokenSigningAlgValuesSupported),
      issuer,
      jwksUri,
      kerberosEndpoint,
      msgraphHost,
      rbacUrl,
      requestUriParameterSupported,
      listEquality.hash(responseModesSupported),
      listEquality.hash(responseTypesSupported),
      listEquality.hash(scopesSupported),
      listEquality.hash(subjectTypesSupported),
      tenantRegionScope,
      tokenEndpoint,
      listEquality.hash(tokenEndpointAuthMethodsSupported),
      userinfoEndpoint,
    ]);
  }

  @override
  String toString() {
    final jsonString = toJsonString(pretty: true);
    return 'OpenIDProviderMetadata $jsonString';
  }
}
