import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/flavor.dart';
import 'package:sbb_oidc_example/pages/home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const routeName = 'login';

  @override
  State<LoginPage> createState() => _State();
}

class _State extends State<LoginPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading ? _loading() : _body(),
      ),
    );
  }

  Widget _loading() {
    return Container(
      alignment: AlignmentDirectional.center,
      child: const CircularProgressIndicator(),
    );
  }

  Widget _body() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _message(context),
        _flavor(context),
        _loginButton(context),
      ],
    );
  }

  Widget _message(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: AlignmentDirectional.center,
        padding: const EdgeInsetsDirectional.all(16),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SBBLogo(color: SBBColors.red, width: 112, height: 56),
            SizedBox(height: 32),
            Text(
              'Login with your SBB account',
              style: SBBTextStyles.largeLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _flavor(BuildContext context) {
    final flavor = DI.get<Flavor>();
    return Container(
      alignment: AlignmentDirectional.center,
      child: Text(
        'Flavor: ${flavor.displayName}',
        style: SBBTextStyles.extraSmallLight,
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      child: SBBPrimaryButton(
        label: 'Login',
        onPressed: _onLoginPressed,
      ),
    );
  }

  void _onLoginPressed() async {
    final authenticator = DI.get<Authenticator>();

    setState(() {
      isLoading = true;
    });

    try {
      await authenticator.login();
      if (mounted) {
        context.navigateToHomePage();
      }
    } catch (e) {
      Fimber.d('Login failed', ex: e);
      if (mounted) {
        SBBToast.of(context).show(message: 'Login failed.');
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}

// Extensions

extension _BuildContextExt on BuildContext {
  void navigateToHomePage() {
    final route = MaterialPageRoute(
      builder: (context) {
        return const HomePage();
      },
    );

    Navigator.pushReplacement(this, route);
  }
}
