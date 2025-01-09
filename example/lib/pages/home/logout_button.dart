import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/login_page.dart';

class LogoutButton extends StatefulWidget {
  const LogoutButton({super.key});

  @override
  State<LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<LogoutButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SBBPrimaryButton(
      label: 'Logout',
      isLoading: isLoading,
      onPressed: () => onPressed(context),
    );
  }

  Future<void> onPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final authenticator = DI.get<Authenticator>();
    try {
      await authenticator.logout();
      if (context.mounted) {
        context.navigateToLoginPage();
      }
    } catch (e) {
      Fimber.e('Logout failed', ex: e);
      if (context.mounted) {
        SBBToast.of(context).show(message: 'Logout failed.');
      }
    }

    setState(() {
      isLoading = false;
    });
  }
}

// Extensions

extension _BuildContextExt on BuildContext {
  void navigateToLoginPage() {
    final route = MaterialPageRoute(
      builder: (context) {
        return const LoginPage();
      },
    );
    Navigator.pushReplacement(this, route);
  }
}
