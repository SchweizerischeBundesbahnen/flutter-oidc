import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/home/end_session_confirmation_sheet.dart';
import 'package:sbb_oidc_example/pages/login_page.dart';

class EndSessionButton extends StatefulWidget {
  const EndSessionButton({super.key});

  @override
  State<EndSessionButton> createState() => _State();
}

class _State extends State<EndSessionButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SBBSecondaryButton(
      labelText: 'End Session',
      isLoading: isLoading,
      onPressed: () => onEndSessionPressed(context),
    );
  }

  Future<void> onEndSessionPressed(BuildContext context) async {
    setState(() => isLoading = true);
    final confirmed = await confirmEndSession(context);
    if (confirmed) {
      final authenticator = DI.get<Authenticator>();
      try {
        await authenticator.endSession();
        if (context.mounted) {
          context.navigateToLoginPage();
        }
      } catch (_) {
        if (context.mounted) {
          SBBToast.of(context).show(
            titleText: 'End session failed.',
            duration: SBBToast.durationLong,
          );
        }
      }
    }
    setState(() => isLoading = false);
  }

  Future<bool> confirmEndSession(BuildContext context) async {
    final confirmed = await EndSessionConfirmationSheet.show(context);
    return confirmed ?? false;
  }
}

extension _BuildContextX on BuildContext {
  void navigateToLoginPage() {
    final route = MaterialPageRoute(
      builder: (context) {
        return const LoginPage();
      },
    );
    Navigator.pushReplacement(this, route);
  }
}
