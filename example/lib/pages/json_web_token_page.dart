import 'dart:convert';

import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
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
          padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 16, 16),
          child: JsonViewer(jwt.header),
        ),
        const Divider(),
        const SBBListHeader('Payload'),
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 16, 16),
          child: JsonViewer(jwt.payload),
        ),
        const Divider(),
        const SBBListHeader('Signature'),
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 24),
          child: Text(
            base64Url.encode(jwt.signature),
          ),
        ),
      ],
    );
  }
}
