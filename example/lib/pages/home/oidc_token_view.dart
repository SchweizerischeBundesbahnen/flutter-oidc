import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/home/json_web_token_list_tile.dart';

class OidcTokenView extends StatefulWidget {
  const OidcTokenView({super.key, required this.tokenId});

  final String tokenId;

  @override
  State<OidcTokenView> createState() => _State();
}

class _State extends State<OidcTokenView> {
  late Future<OidcToken> tokenFuture;
  late String tokenFutureKey;

  @override
  void initState() {
    final authenticator = DI.get<Authenticator>();
    final tokenFuture = authenticator.token(widget.tokenId);
    setTokenFuture(tokenFuture);
    super.initState();
  }

  void setTokenFuture(Future<OidcToken> value) {
    setState(() {
      tokenFutureKey = Random().nextDouble().toString();
      tokenFuture = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<OidcToken>(
      key: ValueKey(tokenFutureKey),
      future: tokenFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _error(context, snapshot.error);
        }
        final token = snapshot.data;
        if (token != null) {
          return _body(context, token);
        }
        return _loading(context);
      },
    );
  }

  Widget _loading(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 50), () => "GO"),
      builder: (context, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.hasData ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                const SBBLoadingIndicator.tiny(),
                Text(
                  'Loading OIDC token',
                  style: Theme.of(context).sbbTextTheme.smallLight,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _error(BuildContext context, dynamic error) {
    const messageStyle = SBBMessageStyle(
      padding: EdgeInsets.all(32),
    );
    if (error is MultiFactorAuthenticationException) {
      return SBBMessage(
        titleText: 'Multi-Factor authentication required.',
        subtitleText: error.details.toString(),
        action: SBBTertiaryButtonSmall(
          labelText: 'Enter second factor',
          onPressed: () => _enterSecondFactor(context),
        ),
        style: messageStyle,
      );
    } else if (error is NoNetworkException) {
      return SBBMessage(
        titleText: 'Network error',
        subtitleText: error.details.toString(),
        action: SBBTertiaryButtonSmall(
          labelText: 'Retry',
          onPressed: () => _retryGetToken(context),
        ),
        style: messageStyle,
      );
    } else {
      return SBBMessage(
        titleText: 'ERROR',
        subtitleText: error.toString(),
        style: messageStyle,
      );
    }
  }

  Widget _body(BuildContext context, OidcToken token) {
    return ListView(
      children: [
        SBBContentBox(
          margin: const EdgeInsets.fromLTRB(8, 16, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: SBBDivider.divideItems(
              context: context,
              items: [
                JsonWebTokenListTile(
                  title: 'Access token',
                  jwt: JsonWebToken.decode(token.accessToken),
                ),
                token.idToken != null
                    ? JsonWebTokenListTile(
                        title: 'ID token',
                        jwt: JsonWebToken.decode(token.idToken!),
                      )
                    : SBBListItem(
                        titleText: 'No ID token',
                        onTap: null,
                      ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
          alignment: AlignmentDirectional.centerEnd,
          child: SBBTertiaryButtonSmall(
            labelText: 'Copy to clipboard',
            onPressed: () => _copyToClipboard(context, token),
          ),
        ),
      ],
    );
  }

  void _retryGetToken(BuildContext context) {
    final authenticator = DI.get<Authenticator>();
    final tokenFuture = authenticator.token(widget.tokenId);
    setTokenFuture(tokenFuture);
  }

  Future<void> _enterSecondFactor(BuildContext context) async {
    final authenticator = DI.get<Authenticator>();
    final tokenFuture = authenticator.login(tokenId: widget.tokenId);
    setTokenFuture(tokenFuture);
  }

  Future<void> _copyToClipboard(BuildContext context, OidcToken token) async {
    final jsonString = token.toJsonString();
    final clipboardData = ClipboardData(text: jsonString);
    await Clipboard.setData(clipboardData);
    if (context.mounted) {
      SBBToast.of(context).show(
        titleText: 'OIDC token copied to clipboard.',
      );
    }
  }
}
