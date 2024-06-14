import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/home/home_page.dart';
import 'package:sbb_oidc_example/pages/login_page.dart';

class EntryPage extends StatelessWidget {
  const EntryPage({super.key});

  Authenticator get authenticator => DI.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return FutureBuilder<bool>(
      future: authenticator.isAuthenticated,
      builder: (context, snapshot) {
        // When the future has emitted a value navigate to the destination
        // page (either login or home page).
        final isDone = snapshot.connectionState == ConnectionState.done;
        if (isDone) {
          // Create an async function which navigates to the home page if the
          // user is authenticated or to the login page if the user is not
          // authenticated.
          navigate() async {
            if (snapshot.data == true) {
              context.navigateToHomePage();
            } else {
              context.navigateToLoginPage();
            }
          }

          // The navigation should happen delayed so that this method can
          // finish.
          Future.delayed(
            const Duration(milliseconds: 500),
            () => navigate(),
          );
        }

        return _loading();
      },
    );
  }

  Widget _loading() {
    return Container(
      alignment: AlignmentDirectional.center,
      color: SBBColors.red,
      child: const SBBLoadingIndicator.tiny(color: SBBColors.white),
    );
  }
}

// Extensions

extension _BuildContextExt on BuildContext {
  void navigateToHomePage() {
    final routeBuilder = PageRouteBuilder(
      pageBuilder: (context, _, __) => const HomePage(),
      transitionDuration: const Duration(seconds: 0),
    );

    Navigator.of(this).pushReplacement(routeBuilder);
  }

  void navigateToLoginPage() {
    final routeBuilder = PageRouteBuilder(
      settings: const RouteSettings(name: LoginPage.routeName),
      pageBuilder: (context, _, __) => const LoginPage(),
      transitionDuration: const Duration(seconds: 0),
    );

    Navigator.of(this).pushReplacement(routeBuilder);
  }
}
