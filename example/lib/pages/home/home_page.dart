import 'dart:io';

import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/home/end_session_button.dart';
import 'package:sbb_oidc_example/pages/home/logout_button.dart';
import 'package:sbb_oidc_example/pages/home/oidc_token_view.dart';
import 'package:sbb_oidc_example/pages/home/user_info_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _State();
}

class _State extends State<HomePage> {
  int index = 0;

  TokenSpecProvider get tokenSpecs {
    return DI.get<TokenSpecProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  SBBHeader _appBar() {
    return const SBBHeader(
      title: 'Home',
    );
  }

  Widget _body() {
    return Column(
      children: [
        _userInfo(),
        _selector(),
        Expanded(
          child: _content(),
        ),
        _footer(),
      ],
    );
  }

  Widget _userInfo() {
    return const UserInfoView();
  }

  Widget _selector() {
    if (tokenSpecs.length <= 1) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      child: SBBSegmentedButton.text(
        values: tokenSpecs.all.map((e) => e.displayName).toList(),
        selectedStateIndex: index,
        selectedIndexChanged: (i) => setState(() {
          index = i;
        }),
      ),
    );
  }

  Widget _content() {
    final tokenId = tokenSpecs[index].id;
    return OidcTokenView(
      key: ValueKey(tokenId),
      tokenId: tokenId,
    );
  }

  Widget _footer() {
    var padding = const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16);
    if (!kIsWeb && Platform.isIOS) {
      padding = const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 32);
    }
    return Container(
      padding: padding,
      child: const Column(
        children: [
          EndSessionButton(),
          SizedBox(height: 8),
          LogoutButton(),
        ],
      ),
    );
  }
}
