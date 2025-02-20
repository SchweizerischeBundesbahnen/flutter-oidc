import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_json_view/flutter_json_view.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';

class JsonWebTokenPage extends StatelessWidget {
  const JsonWebTokenPage({
    super.key,
    required this.title,
    required this.jwt,
  });

  final String title;
  final JsonWebToken jwt;

  Authenticator get authenticator => DI.get();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
    );
  }

  SBBHeader _appBar() {
    return SBBHeader(title: title);
  }

  Widget _body(BuildContext context) {
    return ListView(
      children: [
        const SBBListHeader('Header'),
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: JsonView.map(
            jwt.header,
            theme: const JsonViewTheme(
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        const Divider(),
        const SBBListHeader('Payload'),
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 16),
          child: JsonView.map(
            jwt.payload,
            theme: const JsonViewTheme(
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        const Divider(),
        const SBBListHeader('Signature'),
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 24),
          child: Text(
            base64Url.encode(jwt.signature),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
