import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';

class EndSessionConfirmationSheet {
  static Future<bool?> show(BuildContext context) {
    return showSBBBottomSheet<bool>(
      context: context,
      titleText: 'End Session',
      body: _Body(
        key: const ValueKey('KEY::EndSessionConfirmationSheet'),
      ),
    );
  }
}

class const _Body({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Text(
          'Confirm that you want to end the session.',
          style: Theme.of(context).sbbTextTheme.mediumBold,
        ),
        const Text(
          'You will need to re-enter your login credentials if you want to '
          'use the app again at a later time.',
        ),
        Spacer(),
        SBBPrimaryButton(
          labelText: 'Confirm',
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
