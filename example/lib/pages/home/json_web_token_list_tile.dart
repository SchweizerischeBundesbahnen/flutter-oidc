import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/pages/json_web_token_page.dart';

class JsonWebTokenListTile extends StatelessWidget {
  const JsonWebTokenListTile({
    super.key,
    required this.title,
    required this.jwt,
    this.isLastElement = false,
  });

  final String title;
  final JsonWebToken jwt;
  final bool isLastElement;

  String get expirationState {
    switch (jwt.isExpired) {
      case true:
        return 'Expired';
      case false:
        final expTime = jwt.expirationTime.toIso8601String();
        return 'Expires $expTime';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SBBListItem(
      title: title,
      subtitle: expirationState,
      isLastElement: isLastElement,
      onPressed: () => onPressed(context),
      trailingIcon: SBBIcons.chevron_right_medium,
    );
  }

  Future<void> onPressed(BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) {
        return JsonWebTokenPage(title: title, jwt: jwt);
      },
    );

    Navigator.push(context, route);
  }
}
