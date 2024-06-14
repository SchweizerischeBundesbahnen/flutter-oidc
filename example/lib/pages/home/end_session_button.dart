import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/login_page.dart';

class EndSessionButton extends StatefulWidget {
  const EndSessionButton({super.key});

  @override
  State<EndSessionButton> createState() => _EndSessionButtonState();
}

class _EndSessionButtonState extends State<EndSessionButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SBBSecondaryButton(
      label: 'End Session',
      isLoading: isLoading,
      onPressed: () => onEndSessionPressed(context),
    );
  }

  Future<void> onEndSessionPressed(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    final confirmed = await confirmEndSession(context);
    if (confirmed) {
      final authenticator = DI.get<Authenticator>();
      try {
        await authenticator.endSession();
        if (context.mounted) {
          context.navigateToLoginPage();
        }
      } catch (e) {
        Fimber.e('End session failed', ex: e);
        if (context.mounted) {
          SBBToast.of(context).show(message: 'End session failed.');
        }
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> confirmEndSession(BuildContext context) async {
    final confirmed = await showSBBModalPopup<bool>(
      context: context,
      title: 'End Session',
      child: Container(
        margin: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Confirm that you want to end the session. You will need to re-enter your login credentials if you want to use the app again at a later time.',
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              margin: const EdgeInsetsDirectional.only(top: 8),
              child: SBBTertiaryButtonSmall(
                label: 'OK',
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ),
          ],
        ),
      ),
    );
    return confirmed ?? false;
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
