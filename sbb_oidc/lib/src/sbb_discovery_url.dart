import 'package:meta/meta.dart';

@sealed
@immutable
class SBBDiscoveryUrl {
  const SBBDiscoveryUrl._();

  static const dev =
      'https://login.microsoftonline.com/93ead5cf-4825-45f3-9bc3-813cf64441af/v2.0/.well-known/openid-configuration';

  static const prod =
      'https://login.microsoftonline.com/2cda5d11-f0ac-46b3-967d-af1b2e1bd01a/v2.0/.well-known/openid-configuration';
}
