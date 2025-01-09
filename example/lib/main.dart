import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sbb_oidc_example/app.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/flavor.dart';

void main() async {
  start(Flavor.exampleApp);
}

Future<void> start(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initFimber();
  await _initDotenv(flavor);
  await _initDependencyInjection(flavor);
  runApp(const App());
}

Future<void> _initFimber() async {
  final tree = DebugTree(useColors: true);
  Fimber.plantTree(tree);
}

Future<void> _initDotenv(Flavor flavor) async {
  try {
    await dotenv.load(fileName: flavor.envFile);
  } catch (e, s) {
    Fimber.e('Failed to load ${flavor.envFile}', ex: e, stacktrace: s);
  }
}

Future<void> _initDependencyInjection(Flavor flavor) async {
  await DI.init(flavor);
}
