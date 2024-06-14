import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc_example/pages/entry_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: SBBTheme.light(hostPlatform: HostPlatform.native),
      darkTheme: SBBTheme.dark(hostPlatform: HostPlatform.native),
      home: const EntryPage(),
    );
  }
}
