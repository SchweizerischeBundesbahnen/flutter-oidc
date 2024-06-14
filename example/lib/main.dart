import 'dart:async';

import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sbb_oidc_example/app.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/flavor.dart';

void main() async {
  if (kIsWeb) {
    start(Flavor.web);
  } else {
    start(Flavor.mobile);
  }
}

Future<void> start(Flavor flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initDotenv();
  await _initFimber();
  await _initDependencyInjection(flavor);
  runApp(const App());
}

Future<void> _initDotenv() async {
  await dotenv.load();
}

Future<void> _initFimber() async {
  final tree = DebugTree(useColors: true);
  Fimber.plantTree(tree);
}

Future<void> _initDependencyInjection(Flavor flavor) async {
  await DI.init(flavor);
}
