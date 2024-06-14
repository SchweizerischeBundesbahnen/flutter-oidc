# sbb_oidc_platform_interface 3.2.1

A common platform interface for the [`sbb_oidc`][1] plugin.

This interface allows platform-specific implementations of the `sbb_oidc` plugin, as well as the plugin itself, to ensure they are supporting the same interface.

# Usage

To implement a new platform-specific implementation of `sbb_oidc`, extend [`SBBOidcPlatform`][2] with an implementation that performs the platform-specific behavior, and when you register your plugin, set the default `SBBOidcPlatform` by calling `SBBOidcPlatform.instance = MyPlatformSBBOidc()`.

# Note on breaking changes

Strongly prefer non-breaking changes (such as adding a method to the interface) over breaking changes for this package.

[1]: ../sbb_oidc
[2]: lib/sbb_oidc_platform_interface.dart
