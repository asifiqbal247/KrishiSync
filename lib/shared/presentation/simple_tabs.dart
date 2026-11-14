import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/router.dart';
import '../../core/l10n/formatters.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../features/auth/data/auth_repository.dart';
import '../../features/auth/data/user_repository.dart';
import '../../features/auth/domain/app_user.dart';
import '../../features/trade/data/trade_repository.dart';
import '../../features/trade/domain/trade_models.dart';
import '../../features/transport/data/transport_repository.dart';
import '../../features/transport/domain/delivery.dart';
import '../../features/transport/presentation/transport_common.dart';
import '../../l10n/app_localizations.dart';
import '../services/bd_location_service.dart';
import '../widgets/app_icon.dart';
import '../widgets/ks_app_bar.dart';
import '../widgets/ks_blocks.dart';
import '../widgets/ks_button.dart';
import '../widgets/ks_dialogs.dart';
import '../widgets/ks_list_item.dart';
import '../widgets/ks_net_image.dart';
import '../widgets/ks_option_card.dart';
import '../widgets/ks_toast.dart';

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

/// Profile tab: 68 (farmer, 292:867) / 138 (buyer, 292:1618) /
/// 193 (transporter, 292:1919). Moderator & Admin get header + language +
/// logout. Rows for Tier B/C features stay visible and show "শীঘ্রই আসছে".
class SimpleProfileTab extends ConsumerWidget {
  const SimpleProfileTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final lang = Localizations.localeOf(context).languageCode;
    if (me == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final role = me.role;
    final roleName = switch (role) {
      UserRole.farmer => l.roleFarmer,
      UserRole.buyer => l.rowBuyer,
      UserRole.transporter => l.roleTransporter,
      UserRole.moderator => l.roleModerator,
      UserRole.admin => l.roleAdmin,
      null => '',
    };
    final district = BdPlace.display(me.location.district, lang);
    void soon() => KsToast.comingSoon(context);
    String n(int v) => Fmt.digits(context, '$v');

    final orders = ref.watch(myOrdersProvider).value ?? const <TradeOrder>[];
    final trips = role == UserRole.transporter
        ? (ref.watch(myDeliveriesProvider).value ?? const <Delivery>[])
        : const <Delivery>[];
    final (statLabel, statValue) = switch (role) {
      UserRole.buyer => (l.statTotalOrders, orders.length),
      UserRole.transporter => (
          l.statDoneTrips,
          trips.where((t) => t.status == DeliveryStatus.delivered).length
        ),
      _ => (
          l.statDoneDeals,
          orders.where((o) => o.status == OrderStatus.completed).length
        ),
    };
    final verifySub = switch (me.verification) {
      VerificationStatus.verified => l.verifyDone,
      VerificationStatus.pending => l.verifyPendingSub,
      VerificationStatus.rejected => l.verifyRejectedSub,
      VerificationStatus.none => l.verifyNoneSub,
    };
    final trader = role == UserRole.farmer ||
        role == UserRole.buyer ||
        role == UserRole.transporter;

    Widget row(String title, String? sub, VoidCallback onTap) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.block),
          child: KsListItem(title: title, subtitle: sub, onTap: onTap),
        );

    Future<void> logout() async {
      final ok = await showKsConfirm(context,
          title: l.logoutTitle,
          body: l.logoutBody,
          noLabel: l.noGoBack,
          yesLabel: l.logout);
      if (ok) await ref.read(authRepositoryProvider).signOut();
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.navProfile, showBack: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: me.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: switch (role) {
                UserRole.buyer => AppUi.avatarBuyer,
                UserRole.transporter => AppUi.avatarDriver,
                _ => AppUi.avatarFarmer,
              },
            ),
            title: me.name,
            subtitle: district.isEmpty
                ? roleName
                : l.roleDistrict(roleName, district),
            badge: me.isVerified ? l.verifiedBadge : null,
            // Edit profile is Tier B.
            onTap: soon,
          ),
          if (trader) ...[
            const SizedBox(height: AppSpacing.block),
            Row(children: [
              Expanded(
                child: KsStatCard(
                  label: l.statRating,
                  value: me.ratingCount == 0
                      ? l.notAvailable
                      : l.ratingShort(
                          Fmt.number(context, me.ratingAvg, decimals: 1),
                          n(me.ratingCount)),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                  child: KsStatCard(
                      label: statLabel, value: l.countTi(n(statValue)))),
            ]),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              highlighted: true,
              thumb: const Center(
                  child:
                      AppIcon(AppIcons.verified, color: AppColors.iconBrand)),
              title: l.shareTrack,
              subtitle: l.shareTrackSub,
              trailingText: l.shareLink,
              onTap: soon,
            ),
          ],
          if (role == UserRole.transporter) ...[
            row(
              l.vehicleTitle,
              me.vehicle == null
                  ? null
                  : l.placeDate(vehicleTypeLabel(l, me.vehicle!.type),
                      tonsText(context, me.vehicle!.capacityKg)),
              () => context.push(Routes.trVehicle),
            ),
            row(l.rowVerifyRating, verifySub, soon),
            row(l.rowPayAccount, l.comingSoon, soon),
          ],
          if (role == UserRole.farmer || role == UserRole.buyer) ...[
            row(role == UserRole.farmer ? l.rowNidVerify : l.rowBizVerify,
                verifySub, soon),
            row(role == UserRole.farmer ? l.rowMyRatings : l.rowRatings,
                l.profileReviews(n(me.ratingCount)), soon),
            row(role == UserRole.farmer ? l.rowMyContracts : l.rowContracts,
                l.comingSoon, soon),
            row(l.rowPayMethod, l.comingSoon, soon),
          ],
          row(l.rowLanguage,
              l.languageSub(lang == 'bn' ? l.langBangla : l.langEnglish),
              () => showLanguageSheet(context, ref)),
          if (role == UserRole.farmer || role == UserRole.buyer)
            row(l.rowHelp, l.helpSub, soon),
          row(l.logout, null, logout),
        ],
      ),
    );
  }
}

/// 196 Language Bottom Sheet (Figma 292:1993).
Future<void> showLanguageSheet(BuildContext context, WidgetRef ref) async {
  final current = Localizations.localeOf(context).languageCode;
  final picked = await showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.x2l))),
    builder: (ctx) => _LanguageSheet(initial: current),
  );
  if (picked == null || picked == current) return;
  await ref.read(localeProvider.notifier).set(Locale(picked));
  final uid = ref.read(currentUserProvider).value?.uid;
  if (uid != null) {
    await ref.read(userRepositoryProvider).setLanguage(uid, picked);
  }
}

class _LanguageSheet extends StatefulWidget {
  const _LanguageSheet({required this.initial});
  final String initial;

  @override
  State<_LanguageSheet> createState() => _LanguageSheetState();
}

class _LanguageSheetState extends State<_LanguageSheet> {
  late String _code = widget.initial;
  static const _icon = 36.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.xl,
            AppSpacing.screen, AppSpacing.s2xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.langSheetTitle, style: AppTypography.headingBold20.normal),
            const SizedBox(height: AppSpacing.block),
            KsOptionCard(
              image: const AssetImage(AppImages.langIcon),
              imageSize: _icon,
              title: l.langBangla,
              subtitle: l.langBnSub,
              selected: _code == 'bn',
              onTap: () => setState(() => _code = 'bn'),
            ),
            const SizedBox(height: AppSpacing.block),
            KsOptionCard(
              image: const AssetImage(AppImages.langIcon),
              imageSize: _icon,
              title: l.langEnglish,
              subtitle: l.langEnSub,
              selected: _code == 'en',
              onTap: () => setState(() => _code = 'en'),
            ),
            const SizedBox(height: AppSpacing.block),
            Text(l.langSheetNote,
                style: AppTypography.bodySmall.normal
                    .withColor(AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.block),
            KsButton(
                label: l.commonSave,
                onPressed: () => Navigator.pop(context, _code)),
          ],
        ),
      ),
    );
  }
}
