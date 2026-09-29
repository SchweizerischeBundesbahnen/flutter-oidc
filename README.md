A Flutter package for OpenID Connect (OIDC).

## Table of contents

- [Supported platforms](#supported-platforms)
- [Preconditions](#preconditions)
  * [Redirect URL](#redirect-url)
- [Setup](#setup)
  * [Android](#android)
  * [iOS](#ios)
- [Usage](#usage)
  * [Add dependency](#add-dependency)
  * [Create OIDC client](#create-oidc-client)
  * [Login](#login)
  * [Get tokens](#get-tokens)
  * [Get data about the end-user](#get-data-about-the-end-user)
    + [Get the SBB uid (u/e number)](#get-the-sbb-uid)
  * [Logout](#logout)
  * [End session](#end-session)
  * [Access multiple APIs](#access-multiple-apis)
    + [Multi-Factor authentication](#multi-factor-authentication)
- [Example](#example)

---------------

<a name="supported-platforms"></a>
## Supported platforms

<div id="supported_platforms">
  <img src="https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white" alt="Android badge"/>
  <img src="https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=apple&logoColor=white" alt="iOS badge">
</div>

<a name="preconditions"></a>
## Preconditions

Authentication with OIDC requires the app to be registered with an identity provider. SBB uses Microsoft Entra ID for enterprise applications. You can manage your app registration using the [self-service API][1] or the [SBB API Platform][2]. Detailed documentation is available on this [site][3].

<a name="redirect-url"></a>
### Redirect URL

The redirect URL must contain scheme, host, and path components in the format **scheme://host/path** and be written in lowercase.

`Example: myappname://myhost/redirect`

#### MSAL redirect URL

Applications should use the Microsoft Entra ID-specific redirect URL format whenever possible:

- **Android:** `msauth://<PACKAGE_NAME>/<BASE64_URL_ENCODED_SIGNATURE>`
- **iOS:** `msauth.<BUNDLE_ID>://auth`

See the Microsoft documentation for [Android][4] and [iOS][5].

> **⚠️ This plugin does not enforce the format for backward compatibility.**

<a name="setup"></a>
## Setup

<a name="android"></a>
### Android

> **Minimum SDK version: 24**

Open the [build.gradle.kts][6] file of your app and set the minimum SDK version to 24 or above:

``` groovy
...
android {
    ...
    defaultConfig {
        ...
        minSdk = 24
        ...
    }
}
```

Add `BrowserTabActivity` to the [AndroidManifest.xml][7] of your app as a child of the `<application>` element. It handles the browser callback after authentication. The `scheme`, `host`, and `path` values must match the redirect URL registered with Microsoft Entra ID:

```xml
<activity
    android:name="com.microsoft.identity.client.BrowserTabActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="<scheme>"
            android:host="<host>"
            android:path="/<path>" />
    </intent-filter>
</activity>
```

You also need to request the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
```

<a name="ios"></a>
### iOS

> **Minimum iOS deployment target: 17.0**

Open the [Info.plist][8] of your iOS app to specify the custom scheme. It should contain a section similar to the following, with `<scheme>` replaced by the desired value.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><scheme></string>
        </array>
    </dict>
</array>
```

Also add `LSApplicationQueriesSchemes` to enable integration with the Microsoft Authenticator app if installed:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>msauthv2</string>
  <string>msauthv3</string>
</array>
```

Finally, add your desired keychain access group to the app's [keychain access groups entitlement][9]. See [Create OIDC client](#create-oidc-client) for more details.

<a name="usage"></a>
## Usage

<a name="add-dependency"></a>
### Add dependency

Add `sbb_oidc` as a dependency in your [pubspec.yaml][10] file.

```yaml
sbb_oidc: ^5.0.0
```

<a name="create-oidc-client"></a>
### Create OIDC client

Create an instance of the OIDC client.

```dart
final client = SBBOpenIDConnect.createClient(
  config: OidcClientConfig(
    tenantId: <tenant_id>,
    clientId: <client_id>,
    redirectUrl: <redirect_url>,
    keychainAccessGroup: <keychain_access_group>,
  ),
  enableLogging: <true/false>,
);
```

Here, replace `<client_id>` and `<redirect_url>` with the values registered with your identity provider.

`<tenant_id>` is the unique Microsoft tenant ID of your organisation. The SBB tenant IDs are defined in [sbb_tenant.dart][11]. We recommend using these constants. To implement multi-tenant login, you must use `common` as the tenant ID.

`<keychain_access_group>` is used to cache tokens in iOS. Apps that share the same group get silent SSO between them. Use the app's bundle identifier to keep tokens private. The value must also be declared in the app's [keychain access groups entitlement][9]. For more information, see [Sharing access to keychain items among a collection of apps][12].

<a name="login"></a>
### Login

To authorize and authenticate end users, call the `login()` method. This performs an interactive authorization request. Upon successfully completing the request, the method should return an [OIDC token][13] that contains an access token you can use to access protected APIs.

```dart
final token = await client.login(
  scopes: <your_scopes>,
);
```

<a name="get-tokens"></a>
### Get tokens

Access tokens are short-lived and must be refreshed as soon as they expire. Therefore, your app should not cache the token. Instead, request a token every time it is needed by calling `getToken()`.

```dart
final token = await client.getToken(
  scopes: <your_scopes>,
  forceRefresh: false,
);
```

The OIDC client checks whether the token has expired and refreshes it automatically. You can also force a refresh by setting the `forceRefresh` argument to `true`.

<a name="get-data-about-the-end-user"></a>
### Get data about the end-user

To get data about the signed-in end user, you can either use the [ID token][13] or call `getUserInfo()`.

```dart
final userInfo = await client.getUserInfo(
  scopes: <your_scopes>,
);
```

Using `getUserInfo()` is **not recommended** because it requires multiple HTTP requests to retrieve the data. The ID token contains the same data and requires at most one request if the token must be refreshed.

<a name="get-the-sbb-uid"></a>
#### Get the SBB uid

The SBB UID (u/e number) is specified in the ID token as the `sbbuid` claim.

```dart
final oidcToken = ....
final idToken = JsonWebToken.decode(oidcToken.idToken);
final uid = idToken.payload['sbbuid'] as String;
```

<a name="logout"></a>
### Logout

Logging out deletes all OIDC tokens from the local cache. The user's session remains active on the server, so the user can sign in again without providing credentials.

```dart
await client.logout();
```

<a name="end-session"></a>
### End session

Ending the session logs the user out of the built-in browser and deletes all cached OIDC tokens. The user must provide their credentials to log in again after ending the session.

```dart
await client.endSession();
```

<a name="access-multiple-apis"></a>
### Access multiple APIs

Azure AD has a security limitation: an access token can only be used for one API. An access token can have multiple scopes for one API, but it cannot contain scopes for other APIs. To use multiple APIs, you must request additional tokens with the scopes for the corresponding APIs. This means that the OIDC client has one access token for each API.

Suppose your app needs access to three different APIs:

1. Microsoft Graph with read access to User and Calendar
2. Api 1
3. Api 2

The first step is to log in. As mentioned above, you can use the scopes of only one API, in this case Microsoft Graph. The scopes for this API are:

```
openid, profile, email, offline_access, Calendars.Read, User.Read,
```

```dart
final token = await client.login(
  scopes: [
    'openid',
    'profile',
    'email',
    'offline_access',
    'Calendars.Read',
    'User.Read',
  ],
);
```

The returned token can only be used to access the Microsoft Graph API. To access the other APIs (API 1 and API 2), you must request one additional token for each API using the `getToken()` method.

The scopes for API 1 are:

```
openid, offline_access, api://aaaaaaaa-1111-2222-3333-444444444444/.default,
```

```dart
final tokenForApi1 = await client.getToken(
  scopes: [
    'openid',
    'offline_access',
    'api://aaaaaaaa-1111-2222-3333-444444444444/.default',
  ],
);
```

The scopes for API 2 are:

```
openid, offline_access, api://bbbbbbbb-1111-2222-3333-444444444444/.default,
```

```dart
final tokenForApi2 = await client.getToken(
  scopes: [
    'openid',
    'offline_access',
    'api://bbbbbbbb-1111-2222-3333-444444444444/.default',
  ],
);
```

<a name="multi-factor-authentication"></a>
#### Multi-Factor authentication

Some APIs require multi-factor authentication (MFA), while others do not. In the example above, the Microsoft Graph API does not require MFA, but API 1 and API 2 do. Therefore, `getToken()` will throw a `MultiFactorAuthenticationException`. In this case, you must call `login()` a second time and use the scopes of an API that requires MFA.

```dart
final tokenForApi1 = await client.login(
  scopes: [
    'openid',
    'offline_access',
    'api://aaaaaaaa-1111-2222-3333-444444444444/.default',
  ],
);
```

This opens a pop-up where the user can enter the second factor.

<a name="example"></a>
## Example

See [example app][14].


[1]: https://azure-ad.api.sbb.ch/swagger-ui/index.html?configUrl=/v3/api-docs/swagger-config#/
[2]: https://developer.sbb.ch/home
[3]: https://confluence.sbb.ch/display/IAM/Azure+AD+API%3A+Self-Service+API+for+App+Registrations+with+Entra+ID
[4]: https://learn.microsoft.com/en-us/entra/msal/android/single-sign-on#generate-a-redirect-uri-for-a-broker
[5]: https://learn.microsoft.com/en-us/entra/msal/objc/redirect-uris-ios
[6]: example/android/app/build.gradle.kts
[7]: example/android/app/src/main/AndroidManifest.xml
[8]: example/ios/Runner/Info.plist
[9]: example/ios/Runner/Runner.entitlements
[10]: example/pubspec.yaml
[11]: lib/src/sbb_tenant.dart
[12]: https://developer.apple.com/documentation/security/sharing-access-to-keychain-items-among-a-collection-of-apps?language=objc
[13]: lib/src/oidc_token.dart
[14]: example
