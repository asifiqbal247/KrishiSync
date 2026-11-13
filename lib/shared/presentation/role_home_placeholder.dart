import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/user_repository.dart';
import '../../features/auth/domain/app_user.dart';
import '../../l10n/app_localizations.dart';
import '../widgets/ks_app_bar.dart';
import '../widgets/ks_button.dart';

/// TEMPORARY: replaced by the real role homes in Parts 3–7.
/// Shows real data from users/{uid} so the backend link is visible.
class RoleHomePlaceholder extends ConsumerWidget {
  const RoleHomePlaceholder({super.key, required this.role});
  final UserRole role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final roleName = switch (role) {
      UserRole.farmer => l.roleFarmer,
      UserRole.buyer => l.roleBuyer,
      UserRole.transporter => l.roleTransporter,
      UserRole.moderator => l.roleModerator,
      UserRole.admin => l.roleAdmin,
    };
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: roleName, showBack: false),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(me?.name ?? '', style: AppTypography.h1),
            Text(me?.phone ?? '',
                style: AppTypography.bodyMedium
                    .withColor(AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.lg),
            Text(l.homeComingSoon, style: AppTypography.bodyMedium),
            const Spacer(),
            KsButton(
              label: l.logout,
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}
