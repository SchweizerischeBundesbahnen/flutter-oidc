import 'package:flutter/material.dart';
import 'package:sbb_design_system_mobile/sbb_design_system_mobile.dart';
import 'package:sbb_oidc/sbb_oidc.dart';
import 'package:sbb_oidc_example/auth/authenticator.dart';
import 'package:sbb_oidc_example/auth/token_spec_provider.dart';
import 'package:sbb_oidc_example/di.dart';

class UserInfoView extends StatelessWidget {
  const UserInfoView({super.key});

  Authenticator get authenticator => DI.get<Authenticator>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_ViewModel>(
      future: _ViewModel.future(),
      builder: (context, snapshot) {
        late final Widget child;

        if (snapshot.hasError) {
          child = _error(context, snapshot.error);
        } else if (snapshot.hasData) {
          child = _content(context, snapshot.data!);
        } else {
          child = _loading(context);
        }

        return Stack(
          children: [
            Container(
              color: SBBColors.red,
              height: 39,
            ),
            SBBGroup(
              margin: const EdgeInsetsDirectional.symmetric(horizontal: 8),
              padding: const EdgeInsetsDirectional.all(16),
              useShadow: true,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _error(BuildContext context, dynamic error) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'ERROR',
          style: SBBTextStyles.mediumLight,
        ),
        if (error != null)
          Container(
            margin: const EdgeInsetsDirectional.only(top: 2),
            child: Text(
              error.toString(),
              maxLines: 1,
              style: SBBTextStyles.smallLight,
            ),
          ),
      ],
    );
  }

  Widget _content(BuildContext context, _ViewModel vm) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsetsDirectional.only(end: 16),
          child: _picture(context, vm),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                vm.userInfo.name ?? '-',
                style: SBBTextStyles.mediumLight,
              ),
              const SizedBox(height: 2),
              Text(
                vm.userInfo.email ?? '-',
                style: SBBTextStyles.smallLight,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _picture(BuildContext context, _ViewModel vm) {
    return CircleAvatar(
      backgroundColor: SBBColors.cloud,
      foregroundImage: vm.hasPicture
          ? NetworkImage(
              vm.userInfo.picture!,
              headers: {
                'Authorization': vm.authorizationHeader,
              },
            )
          : null,
    );
  }

  Widget _loading(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      child: const SBBLoadingIndicator.tiny(),
    );
  }
}

//

class _ViewModel {
  const _ViewModel(
    this.token,
    this.userInfo,
  );

  final OidcToken token;
  final UserInfo userInfo;

  static Future<_ViewModel> future() async {
    final auth = DI.get<Authenticator>();
    final tokenSpecProvider = DI.get<TokenSpecProvider>();
    final tokenSpec = tokenSpecProvider.first;
    final token = await auth.token(tokenSpec.id);
    final userInfo = await auth.userInfo();
    return _ViewModel(token, userInfo);
  }

  bool get hasPicture {
    return userInfo.picture != null;
  }

  String get authorizationHeader {
    return '${token.tokenType} ${token.accessToken}';
  }
}
