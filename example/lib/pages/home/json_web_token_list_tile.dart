import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/pages/json_web_token_page.dart';

class JsonWebTokenListTile extends StatelessWidget {
  const JsonWebTokenListTile({
    super.key,
    required this.title,
    required this.jwt,
  });

  final String title;
  final JsonWebToken jwt;

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
      titleText: title,
      subtitleText: expirationState,
      trailingIconData: SBBIcons.chevron_right_medium,
      onTap: () => onPressed(context),
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
