# sbb_oidc 4.0.0

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
    + [SBB discovery URLs](#sbb-discovery-urls)
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

Authentication with OIDC requires the app to be registered with an Identity Provider. SBB uses Azure AD for enterprise applications. You can manage your app registration using the [self-service API][1] or the [SBB API Platform][4]. Detailed documentation is available on this [Site][2].

<a name="redirect-url"></a>
### Redirect URL

The redirect URL must contain a scheme, host and path component in the format **scheme://host/path** and and be written in lowercase.

`Example: myappname://myhost/redirect`

The iOS SDK has some logic to validate the redirect URL to see if it should be responsible for processing the redirect. This appears to be failing under certain circumstances. Adding a trailing slash to the redirect URL specified in your code fixes the issue.

<a name="setup"></a>
## Setup

<a name="android"></a>
### Android

Go to the [build.gradle][10] file for your Android app to specify the custom scheme. There should be a section in it that looks similar to the following but replace `<your_custom_scheme>` with the desired value. Ensure that the value of `<your_custom_scheme>` is all in lowercase.

``` groovy
...
android {
    ...
    defaultConfig {
        ...
        manifestPlaceholders += [
                'appAuthRedirectScheme': '<your_custom_scheme>'
        ]
    }
}
```

Also set the minSdkVersion to 21 or above.

``` groovy
...
android {
    ...
    defaultConfig {
        ...
        minSdkVersion 21
        ...
    }
}
```

<a name="android-backup"></a>
#### Android Backup

Samsung devices with Android 9.0 or newer may experience crashes related to backups because the devices restore shared preferences. Because of this, the shared preferences must be excluded from the backup. There are two options:

##### 1. Disable backup completely.

Go to the [Manifest.xml][11] file for your Android app and add the `android:allowBackup` attribute to the `<application>` element.

``` xml
...
<application
    ...
        android:allowBackup="false">
```

##### 2. Keep backup enabled but exclude the shared preferences used by this plugin.

Go to the [Manifest.xml][11] file for your Android app and add the `android:allowBackup` and the `android:fullBackupContent` attributes to the `<application>` element.

``` xml
...
<application
    ...
        android:allowBackup="true" 
        android:fullBackupContent="@xml/backup_rules">
```

Create or edit [backup_rules.xml][16] and exclude the shared preferences used by this plugin.

``` xml
<?xml version="1.0" encoding="utf-8"?>
<full-backup-content>
    <exclude domain="sharedpref" path="FlutterSecureStorage"/>
</full-backup-content>
```

If your app targets Android 12 (API level 31) or higher you must specify an additional set of XML backup rules. Go to the [Manifest.xml][11] file for your Android app and add the `android:dataExtractionRules` attribute to the `<application>` element. This attribute points to an XML file that contains backup rules.

``` xml
...
<application
    ...
        android:dataExtractionRules="@xml/data_extraction_rules">
```

Create or edit [data_extraction_rules.xml][17] and exclude the shared preferences used by this plugin.

``` xml
<?xml version="1.0" encoding="utf-8"?>
<data-extraction-rules>
    <cloud-backup>
        <include domain="sharedpref" path="."/>
        <exclude domain="sharedpref" path="FlutterSecureStorage"/>
    </cloud-backup>
</data-extraction-rules>
```

<a name="ios"></a>
### iOS

Go to the [Info.plist][12] for your iOS app to specify the custom scheme. There should be a section in it that looks similar to the following but replace `<your_custom_scheme>` with the desired value.

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string><your_custom_scheme></string>
        </array>
    </dict>
</array>
```

<a name="usage"></a>
## Usage

<a name="add-dependency"></a>
### Add dependency

Add `sbb_oidc` as a dependency in your [pubspec.yaml][14] file.

```yaml
sbb_oidc: ^4.0.0
```

<a name="create-oidc-client"></a>
### Create OIDC client

Create an instance of the OIDC client.

```dart
final client = SBBOpenIDConnect.createClient(
  discoveryUrl: <discovery_url>,
  clientId: <client_id>,
  redirectUrl: <redirect_url>,
);
```

Here the `<client_id>` and `<redirect_url>` should be replaced by the values registered with your identity provider. The `<discovery_url>` is the URL of the discovery endpoint exposed by your identity provider. The endpoint will return a document containing information about the OAuth 2.0 endpoints among other things.

<a name="sbb-discovery-urls"></a>
#### SBB discovery URLs

The SBB discovery URLs are defined in [sbb_discovery_url.dart][20]. It is recommended to use these constants.

| Environment | Discovery URL |
| ----------- | ------------- |
| DEV         | https://login.microsoftonline.com/93ead5cf-4825-45f3-9bc3-813cf64441af/v2.0/.well-known/openid-configuration |
| PROD        | https://login.microsoftonline.com/2cda5d11-f0ac-46b3-967d-af1b2e1bd01a/v2.0/.well-known/openid-configuration |

<a name="login"></a>
### Login

To Authorize and authenticate end-users call the `login()` method. This will perform an authorization request and automatically exchange the authorization code. Upon completing the request successfully, the method should return an [OIDC token][30] that contains an access token which you can use to access protected APIs.

```dart
final token = await client.login(
  scopes: <your_scopes>,
);
```

<a name="get-tokens"></a>
### Get tokens

Access tokens are short-lived and must be refreshed as soon as they expire. Therefore you app should not cache the token. Instead the app should request the token every time it needs it by calling `getToken()`.

```dart
final token = await client.getToken(
  scopes: <your_scopes>,
  forceRefresh: false,
);
```

The OIDC client checks if the token is expired and refreshes it automatically. You can also force a refresh by settings the `forceRefresh` argument to `true`.

<a name="get-data-about-the-end-user"></a>
### Get data about the end-user

To get data about the signed in end-user you can either use the [ID token][30] or call `getUserInfo()`. 

```dart
final userInfo = await client.getUserInfo(
  scopes: <your_scopes>,
);
```

Using `getUserInfo()` is **not recommendet** because in requires multiple HTTP requests to get the data. The ID token contains the same data and requires at most one request if the token must be refreshed.

<a name="get-the-sbb-uid"></a>
#### Get the SBB uid

The SBB uid  (u/e Number) is specified in the ID token as `sbbuid` claim. 

```dart
final oidcToken = ....
final idToken = oidcToken.idToken;
final uid = idToken.payload['sbbuid'] as String;
```

<a name="logout"></a>
### Logout

Logout deletes all OIDC Tokens from the local cache. The user's session will remain active on the server and the user can be signed back in without providing credentials again.

```dart
await client.logout()
```

<a name="end-session"></a>
### End session

> **❌ End session does not work properly on mobile devices.**

End session is used for logging out of the built-in browser and deleting all cached OIDC tokens.

```dart
await client.endSession()
```

<a name="access-multiple-apis"></a>
### Access multiple APIs

AzureAD has a security limitation: an access token can only be used for one API. The access token can have multiple scopes for one API, but it cannot contain scope(s) of other APIs. In order to use multiple APIs, you must request additional tokens with the scope(s) of the corrensponding API. This means that the OIDC client will have one access token for each API.

Let's assume that your app neds access to three different APIs:

1. Microsoft Graph with read acceess to User and Calendar
2. Api 1
3. Api 2

The first step is to login. As mentioned above you can only use the scopes of one API, in this case Microsoft Graph. The scopes for this API are:

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

The returned token can only be used to access the MIcrosoft Graph API. To access other APIs (Api 1 and Api 2) you must request one additional token for each API by using the `getToken()` method.

The scopes for Api 1 are:

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

The scopes for Api 2 are:

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

Some APIS require Multi-Factor authentication (MFA) while others don't. In the example above the Microsoft Graph API does not require MFA but Api 1 and Api 2 do. Therefore `getToken()` will throw a [MultiFactorAuthenticationException][31]. In this case you must call `login()` a second time and use the scopes of an API that requires MFA.

```dart
final tokenForApi1 = await client.login(
  scopes: [
    'openid',
    'offline_access',
    'api://aaaaaaaa-1111-2222-3333-444444444444/.default',
  ],
);
```

This will open a popup where the user can enter the second factor.

<a name="example"></a>
## Example

See [example app][15].


[1]: https://azure-ad.api.sbb.ch/swagger-ui/index.html?configUrl=/v3/api-docs/swagger-config#/
[2]: https://confluence.sbb.ch/display/IAM/Azure+AD+API%3A+Self-Service+API+for+App+Registrations+with+Azure+AD#
[3]: https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/cdn-usage.md
[4]: https://developer.sbb.ch/home
[10]: example/android/app/build.gradle
[11]: example/android/app/src/main/AndroidManifest.xml
[12]: example/ios/Runner/Info.plist
[13]: example/web/index.html
[14]: example/pubspec.yaml
[15]: example
[16]: example/android/app/src/main/res/xml/backup_rules.xml
[17]: example/android/app/src/main/res/xml/data_extraction_rules.xml
[20]: sbb_oidc/lib/src/sbb_discovery_url.dart
[30]: sbb_oidc_platform_interface/lib/src/types/oidc_token.dart
[31]: sbb_oidc_platform_interface/lib/src/exceptions/multi_factor_authentication_exception.dart
