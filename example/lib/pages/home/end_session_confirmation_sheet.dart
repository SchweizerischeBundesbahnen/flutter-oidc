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
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        spacing: 8,
        children: [
          const Text(
            'Confirm that you want to end the session. You will need to '
            're-enter your login credentials if you want to use the app again '
            'at a later time.',
          ),
          SBBPrimaryButton(
            labelText: 'OK',
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );
  }
}
