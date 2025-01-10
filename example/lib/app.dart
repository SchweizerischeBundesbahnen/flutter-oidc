import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc_example/pages/entry_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SBBTheme.light(),
      darkTheme: SBBTheme.dark(),
      home: const EntryPage(),
    );
  }
}
