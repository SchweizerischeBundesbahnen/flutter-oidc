import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc_example/auth/token_spec.dart';
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
      body: SafeArea(
        child: _body(),
      ),
    );
  }

  SBBHeader _appBar() {
    return const SBBHeader(
      titleText: 'Home',
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
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
      child: SBBSegmentedButton<int>(
        segments: tokenSpecs.all.toButtonSegments(),
        selected: index,
        onSelectionChanged: (value) => setState(() => index = value),
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
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
      child: const Column(
        spacing: 8,
        children: [
          EndSessionButton(),
          LogoutButton(),
        ],
      ),
    );
  }
}

extension _TokenSpecListX on List<TokenSpec> {
  List<SBBButtonSegment<int>> toButtonSegments() {
    return mapIndexed((index, spec) {
      return SBBButtonSegment(
        value: index,
        labelText: spec.displayName,
      );
    }).toList();
  }
}
