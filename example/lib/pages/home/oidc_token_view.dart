import 'dart:math';

import 'package:design_system_flutter/design_system_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/di.dart';
import 'package:sbb_oidc_example/pages/home/json_web_token_list_tile.dart';

class OidcTokenView extends StatefulWidget {
  const OidcTokenView({
    super.key,
    required this.tokenId,
  });

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
      builder: (constext, snapshot) {
        return AnimatedOpacity(
          opacity: snapshot.hasData ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SBBLoadingIndicator.tiny(),
                Container(
                  margin: const EdgeInsetsDirectional.only(top: 8, bottom: 24),
                  child: const Text(
                    'Loading OIDC token',
                    style: SBBTextStyles.smallLight,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _error(BuildContext context, dynamic error) {
    if (error is MultiFactorAuthenticationException) {
      return _ErrorViews.multiFactorAuthenticationError(
        context: context,
        exception: error,
        onEnterSecondFactorPressed: (context) => enterSecondFactor(context),
      );
    }
    if (error is NetworkException) {
      return _ErrorViews.networkError(
        context: context,
        exception: error,
        onRetryPressed: (context) => retryGetToken(context),
      );
    }

    final textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: SBBGroup(
        margin: const EdgeInsetsDirectional.all(16),
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ERROR', style: textTheme.titleLarge),
            if (error != null)
              Container(
                margin: const EdgeInsetsDirectional.only(top: 8),
                child: Text(error.toString(), style: textTheme.bodySmall),
              ),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, OidcToken token) {
    return ListView(
      children: [
        SBBGroup(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 16, 8, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              JsonWebTokenListTile(
                title: 'Access token',
                jwt: token.accessToken.toJwt(),
              ),
              JsonWebTokenListTile(
                title: 'ID token',
                jwt: token.idToken,
                isLastElement: true,
              ),
            ],
          ),
        ),
        //
        Container(
          margin: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 16),
          alignment: AlignmentDirectional.centerEnd,
          child: SBBTertiaryButtonSmall(
            label: 'Copy to clipboard',
            onPressed: () => copyToClipboard(context, token),
          ),
        ),
      ],
    );
  }

  //

  void retryGetToken(BuildContext context) {
    final authenticator = DI.get<Authenticator>();
    final tokenFuture = authenticator.token(widget.tokenId);
    setTokenFuture(tokenFuture);
  }

  Future<void> enterSecondFactor(BuildContext context) async {
    final authenticator = DI.get<Authenticator>();
    final tokenFuture = authenticator.login(tokenId: widget.tokenId);
    setTokenFuture(tokenFuture);
  }

  Future<void> copyToClipboard(BuildContext context, OidcToken token) async {
    final jsonString = token.toJsonString();
    final clipboardData = ClipboardData(text: jsonString);
    await Clipboard.setData(clipboardData);
    if (context.mounted) {
      SBBToast.of(context).show(
        message: 'OIDC token copied to clipboard.',
      );
    }
  }
}

class _ErrorViews {
  const _ErrorViews._();

  static Widget multiFactorAuthenticationError({
    required BuildContext context,
    required MultiFactorAuthenticationException exception,
    required Function(BuildContext context) onEnterSecondFactorPressed,
  }) {
    return SingleChildScrollView(
      child: SBBGroup(
        margin: const EdgeInsetsDirectional.all(16),
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ERROR',
              style: SBBTextStyles.largeLight,
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8),
              child: const Text(
                'Multi-Factor authentication required.',
                style: SBBTextStyles.mediumLight,
              ),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8),
              child: Text(
                exception.cause.toString(),
                style: SBBTextStyles.extraSmallLight,
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
              child: SBBTertiaryButtonSmall(
                label: 'Enter second factor',
                onPressed: () => onEnterSecondFactorPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget networkError({
    required BuildContext context,
    required NetworkException exception,
    required Function(BuildContext context) onRetryPressed,
  }) {
    return SingleChildScrollView(
      child: SBBGroup(
        margin: const EdgeInsetsDirectional.all(16),
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Network error',
              style: SBBTextStyles.largeLight,
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(top: 8),
              child: Text(
                exception.cause.toString(),
                style: SBBTextStyles.extraSmallLight,
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              margin: const EdgeInsetsDirectional.fromSTEB(0, 16, 16, 0),
              child: SBBTertiaryButtonSmall(
                label: 'Retry',
                onPressed: () => onRetryPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
