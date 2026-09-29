# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

## [5.0.0]

- Replaced AppAuth with native MSAL libraries for Android and iOS.
- Removed CocoaPods support and migrated the iOS integration to Swift Package Manager.
- **Breaking:** `SBBOpenIDConnect.createClient` now requires an `OidcClientConfig` and accepts an optional `enableLogging` flag in place of the individual configuration parameters.
- Added `OidcClientConfig` for OIDC client settings and `SBBTenant` for the SBB development and production tenant IDs.
- **Breaking:** In `OidcToken`, renamed `tokenType` to `accessTokenType`, removed `refreshToken` and `isExpired`, and made `idToken` nullable. Added `authorizationHeader` and optional masking when serializing tokens to JSON.
- **Breaking:** Exceptions now use `OidcException`, which exposes `code`, `message`, and `details` instead of `cause`. Specialized subtypes are available for specific error conditions.
- **Breaking:** Removed the public `OpenIDProviderMetadata`, `SBBDiscoveryUrl`, and `TokenAccessibility` types.
- Updated Dart version to 3.13.2
- Updated Flutter version to 3.47.2
- Updated all dependencies to latest versions

## [4.5.0]

- Updated Dart version to 3.11.4
- Updated Flutter version to 3.41.6
- Updated all dependencies to latest versions

## [4.4.0]

- Updated Dart version to 3.10.0
- Updated Flutter version to 3.38.3
- Updated all dependencies to latest versions

## [4.3.0]

- Add optional app installation id parameter to OIDC client factory method

## [4.2.0]

- Update Dart version to 3.8.1
- Update Flutter version to 3.32.4
- Update all dependencies to latest versions

## [4.1.0]

- Make token accessibility configurable on iOS.

## [4.0.1]

- Export SBB Discovery URLs

## [4.0.0]

- **Dropped support for Web**
- Changed type of `accessToken` and `idToken` in `OidcToken` to String
- Updated min Dart version to 3.6.0
- Updated Flutter version to 3.27.1
- Updated all dependencies to latest versions
