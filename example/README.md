# sbb_oidc_example

This app demonstrates how to use the `sbb_oidc` plugin. 

## Setup

This app uses the [dotenv] package to load configuration at runtime from an `.env` file. Before you can run the example app create the `.env` file and add the following content:

```
DISCOVERY_URL=<The discovery url of your azure ad identity provider>
CLIENT_ID=<The client id of your app>
SCOPES=<The scopes that your app requires>
MOBILE_REDIRECT_URL=<The redirect url of your mobile app>
WEB_REDIRECT_URL=<The redirect url of your web app>
```

## Run the app

To run the app `cd` into the root dir of the example and execute one of the following commands:

**Mobile**

```shell
flutter run -t lib/main.dart
```

**Web**

```shell
flutter run -t lib/main.dart -d chrome --web-hostname localhost --web-port 4200
```

> The web flavor of this example app will only work on localhost



[dotenv]: https://pub.dev/packages/flutter_dotenv
