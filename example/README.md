# sbb_oidc_example

This app demonstrates how to use the `sbb_oidc` package. 

## Setup

This app uses the [dotenv] package to load configuration at runtime from an `.env` file. Before you can run the example app create the `example_app.env` file in the `assets` dir and add the following content:

```
DISCOVERY_URL=<The discovery url of your azure ad identity provider>
CLIENT_ID=<The client id of your app>
SCOPES=<The scopes that your app requires>
MOBILE_REDIRECT_URL=<The redirect url of your mobile app>
```

If you want to use other flavors you must create one `.env` file for each flavor. The content of the files may differ. Check the authenticator config factory functions defined in [flavor] to find out the exact content for each flavor.

## Run the app

To run the app `cd` into the root dir of the example and execute the following command:

```sh
flutter run -t lib/main.dart
```

To run a different flavor, you must change the `main.dart` to the one of the flavor you want to run:

```sh
flutter run -t lib/main_esq_mobile_dev.dart
```



[dotenv]: https://pub.dev/packages/flutter_dotenv
[flavor]: lib/flavor.dart
