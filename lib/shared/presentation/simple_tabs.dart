import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/router.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/user_repository.dart';
import '../../features/auth/domain/app_user.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/ks_app_bar.dart';
import '../widgets/ks_blocks.dart';
import '../widgets/ks_button.dart';
import '../widgets/ks_list_item.dart';
import '../widgets/ks_net_image.dart';
import '../widgets/ks_pill.dart';

/// Tab whose real screen is built in a later Part.
class ComingTab extends StatelessWidget {
  const ComingTab({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: title, showBack: false),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.screen),
          child: Text(
            l.tabComingTitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.withColor(AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

/// Basic profile tab (all roles): name, phone, role, language switch,
/// logout. Full Profile screens (68 / 138 / 193) replace it later.
class SimpleProfileTab extends ConsumerWidget {
  const SimpleProfileTab({super.key});

  static const _avatar = 72.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final lang = Localizations.localeOf(context).languageCode;
    final roleName = switch (me?.role) {
      UserRole.farmer => l.roleFarmer,
      UserRole.buyer => l.roleBuyer,
      UserRole.transporter => l.roleTransporter,
      UserRole.moderator => l.roleModerator,
      UserRole.admin => l.roleAdmin,
      null => '',
    };

    Future<void> setLang(String code) async {
      await ref.read(localeProvider.notifier).set(Locale(code));
      final uid = me?.uid;
      if (uid != null) {
        await ref.read(userRepositoryProvider).setLanguage(uid, code);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.navProfile, showBack: false),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screen),
        children: [
          Center(
            child: ClipOval(
              child: SizedBox.square(
                dimension: _avatar,
                child: KsNetImage(
                  url: me?.photoUrl,
                  fallbackAsset: switch (me?.role) {
                    UserRole.buyer => AppUi.avatarBuyer,
                    UserRole.transporter => AppUi.avatarDriver,
                    _ => AppUi.avatarFarmer,
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: Text(
              me?.name ?? '',
              style: AppTypography.headingBold20.normal,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoCard(
            rows: [
              (l.profilePhone, me?.phone ?? ''),
              (l.profileRole, roleName),
            ],
          ),
          if (me?.role == UserRole.transporter) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              title: l.vehicleTitle,
              subtitle: me?.vehicle?.plateNo,
              onTap: () => context.push(Routes.trVehicle),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          Text(
            l.profileLanguage,
            style: AppTypography.bodyMediumEmphasis.normal,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: [
              KsPill(
                label: l.langBangla,
                selected: lang == 'bn',
                onTap: () => setLang('bn'),
              ),
              KsPill(
                label: l.langEnglish,
                selected: lang == 'en',
                onTap: () => setLang('en'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3xl),
          KsButton.outline(
            label: l.logout,
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }
}
