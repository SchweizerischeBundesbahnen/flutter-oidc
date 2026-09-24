import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logging/logging.dart';
import 'package:sbb_oidc_example/app.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/flavor.dart';

final _log = Logger('main');

void main() {
  start(Flavor.exampleApp);
}

Future<void> start(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeLogging(flavor);
  await _initializeDotenv(flavor);
  await _initializeDependencyInjection(flavor);
  runApp(const App());
}

void _initializeLogging(Flavor flavor) {
  Logger.root.level = flavor.logLevel;
  Logger.root.onRecord.listen(flavor.logPrinter.call);
}

Future<void> _initializeDotenv(Flavor flavor) async {
  try {
    await dotenv.load(fileName: flavor.envFile);
  } catch (e, s) {
    _log.severe('Failed to load ${flavor.envFile}', e, s);
    exit(1);
  }
}

Future<void> _initializeDependencyInjection(Flavor flavor) async {
  try {
    await DI.initialize(flavor);
  } catch (e, s) {
    _log.severe('Initialize DI failed', e, s);
    exit(1);
  }
}
