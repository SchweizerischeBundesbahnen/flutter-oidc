import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
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
      alignment: Alignment.center,
      child: SBBLoadingIndicator.tiny(),
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
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SBBLogo(
              color: SBBColors.red,
              width: 112,
              height: 56,
            ),
            const SizedBox(height: 32),
            Text(
              'Login with your SBB account',
              style: Theme.of(context).sbbTextTheme.largeLight,
            ),
          ],
        ),
      ),
    );
  }

  Widget _flavor(BuildContext context) {
    final flavor = DI.get<Flavor>();
    return Container(
      alignment: Alignment.center,
      child: Text(
        'Flavor: ${flavor.displayName}',
        style: Theme.of(context).sbbTextTheme.xxSmallLight,
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SBBPrimaryButton(
        labelText: 'Login',
        onPressed: _onLoginPressed,
      ),
    );
  }

  void _onLoginPressed() async {
    final authenticator = DI.get<Authenticator>();
    setState(() => isLoading = true);
    try {
      await authenticator.login();
      if (mounted) {
        context.navigateToHomePage();
      }
    } on LoginCanceledException catch (_) {
      // ignore
    } catch (e) {
      if (mounted) {
        SBBToast.of(context).show(
          titleText: 'Login failed.',
          duration: SBBToast.durationLong,
        );
      }
    }
    setState(() => isLoading = false);
  }
}

extension _BuildContextX on BuildContext {
  void navigateToHomePage() {
    final route = MaterialPageRoute(
      builder: (context) {
        return const HomePage();
      },
    );
    Navigator.pushReplacement(this, route);
  }
}
