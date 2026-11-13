import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_option_card.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';
import '../domain/app_user.dart';

/// 14 Role Selection (Figma 292:347). Tapping a role saves it.
class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  UserRole _selected = UserRole.farmer; // Figma shows কৃষক selected
  bool _saving = false;
  String? _error;

  Future<void> _choose(UserRole role) async {
    if (_saving) return;
    setState(() {
      _selected = role;
      _saving = true;
      _error = null;
    });
    final uid = ref.read(authRepositoryProvider).currentUser?.uid;
    try {
      if (uid != null) {
        await ref.read(userRepositoryProvider).setRole(uid, role);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _error = AppLocalizations.of(context).errorGeneric);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final options = [
      (UserRole.farmer, AppImages.farmerM, l.roleFarmer, l.roleFarmerSub),
      (UserRole.buyer, AppImages.buyerP, l.roleBuyer, l.roleBuyerSub),
      (
        UserRole.transporter,
        AppImages.truckRoad,
        l.roleTransporter,
        l.roleTransporterSub
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.roleTitle,
        onBack: () => ref.read(authRepositoryProvider).signOut(),
      ),
      body: SafeArea(
        top: false,
        child: AbsorbPointer(
          absorbing: _saving,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
            children: [
              Text(l.roleSub,
                  style: AppTypography.bodyMedium.normal
                      .withColor(AppColors.textSecondary)),
              for (final (role, img, title, sub) in options) ...[
                const SizedBox(height: AppSpacing.block),
                KsOptionCard(
                  image: AssetImage(img),
                  title: title,
                  subtitle: sub,
                  selected: _selected == role,
                  onTap: () => _choose(role),
                ),
              ],
              if (_saving) ...[
                const SizedBox(height: AppSpacing.s2xl),
                const Center(child: CircularProgressIndicator()),
              ],
              if (_error != null) ...[
                const SizedBox(height: AppSpacing.block),
                Text(_error!,
                    style: AppTypography.caption
                        .withColor(AppColors.textError)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
