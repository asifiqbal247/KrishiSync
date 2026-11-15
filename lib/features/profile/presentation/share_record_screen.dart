import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../transport/data/transport_repository.dart';
import '../../transport/domain/delivery.dart';
import '../../transport/presentation/transport_common.dart';

/// Numbers for the record card, all from the user's real orders / trips.
class _Record {
  const _Record(this.deals, this.onTimePct, this.money);
  final int deals;
  final int? onTimePct; // null when there is nothing to measure yet
  final num money;
}

_Record _forOrders(List<TradeOrder> orders, bool farmer) {
  final done = orders
      .where(
        (o) =>
            o.status == OrderStatus.completed ||
            o.status == OrderStatus.delivered,
      )
      .toList();
  // On time = crop loaded by the end of the agreed pickup day.
  final measured = orders.where(
    (o) => o.pickupDate != null && o.timeline['pickedUp'] != null,
  );
  final onTime = measured.where((o) {
    final p = o.pickupDate!;
    return !o.timeline['pickedUp']!.isAfter(
      DateTime(p.year, p.month, p.day + 1),
    );
  }).length;
  return _Record(
    done.length,
    measured.isEmpty ? null : (onTime * 100 / measured.length).round(),
    done.fold<num>(0, (a, o) => a + (farmer ? o.cropTotal : o.total)),
  );
}

_Record _forTrips(List<Delivery> trips) {
  final done = trips
      .where((t) => t.status == DeliveryStatus.delivered)
      .toList();
  // On time = delivered within pickup day + road time + 1 day.
  final measured = done.where(
    (t) => t.pickupDate != null && t.timeline['delivered'] != null,
  );
  final onTime = measured.where((t) {
    final due = t.pickupDate!.add(Duration(days: 1, hours: t.hours ?? 0));
    return !t.timeline['delivered']!.isAfter(due);
  }).length;
  return _Record(
    done.length,
    measured.isEmpty ? null : (onTime * 100 / measured.length).round(),
    done.fold<num>(0, (a, t) => a + fareOf(t)),
  );
}

/// 64 / 131 / 188 Share Track Record (Figma 292:2766). The QR code and the
/// shared text carry the same verified summary.
class ShareRecordScreen extends ConsumerStatefulWidget {
  const ShareRecordScreen({super.key});

  @override
  ConsumerState<ShareRecordScreen> createState() => _ShareRecordState();
}

class _ShareRecordState extends ConsumerState<ShareRecordScreen> {
  bool _deals = true;
  bool _ratings = true;
  bool _money = false;
  static const _qr = 64.0;
  static const _avatar = 48.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    if (me == null) return const Scaffold(body: KsSkeletonList());
    final transporter = me.role == UserRole.transporter;
    final rec = transporter
        ? _forTrips(ref.watch(myDeliveriesProvider).value ?? const [])
        : _forOrders(
            ref.watch(myOrdersProvider).value ?? const [],
            me.role == UserRole.farmer,
          );
    final roleName = switch (me.role) {
      UserRole.farmer => l.roleFarmer,
      UserRole.buyer => l.rowBuyer,
      UserRole.transporter => l.roleTransporter,
      _ => '',
    };
    final district = BdPlace.display(me.location.district, lang);
    final code = 'GH-${me.uid.substring(0, 6).toUpperCase()}';
    final dealsText = l.countTi(Fmt.digits(context, '${rec.deals}'));
    final onTime = rec.onTimePct == null
        ? l.notAvailable
        : '${Fmt.digits(context, '${rec.onTimePct}')}%';
    final rating = me.ratingCount == 0
        ? l.notAvailable
        : Fmt.number(context, me.ratingAvg, decimals: 1);
    final since = me.createdAt == null
        ? l.notAvailable
        : l.memberSince(Fmt.digits(context, '${me.createdAt!.year}'));
    final statLabel = transporter ? l.statDoneTrips : l.statDoneDeals;

    final summary = [
      l.shareHeader,
      '${me.name} · $roleName${district.isEmpty ? '' : ' · $district'}',
      if (me.isVerified) l.verifiedBadge,
      if (_deals) '$statLabel: $dealsText · ${l.statOnTime}: $onTime',
      if (_ratings)
        '${l.statRatingReviews(Fmt.digits(context, '${me.ratingCount}'))}: $rating',
      if (_money) l.shareMoneyLine(Fmt.taka(context, rec.money)),
      '${l.memberLabel}: $since',
      l.shareCode(code),
    ].join('\n');

    Widget stat(String value, String label) => Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x10,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.bgPage,
          borderRadius: BorderRadius.circular(AppRadius.statTile),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value, style: AppTypography.bold17.normal),
            Text(
              label,
              style: AppTypography.labelSmall.normal.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );

    Widget toggle(String title, bool on, ValueChanged<bool> set) => KsListItem(
      title: title,
      subtitle: on ? l.visibleAll : l.hiddenPrivacy,
      trailingText: on ? l.onLabel : l.offLabel,
      showChevron: false,
      onTap: () => setState(() => set(!on)),
    );

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.shareTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          // Verified Track Record Card (292:2770).
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.x10,
            ),
            decoration: BoxDecoration(
              color: AppColors.bgSurface,
              borderRadius: BorderRadius.circular(AppRadius.xl),
              border: Border.all(color: AppColors.borderBrand, width: 2),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: SizedBox.square(
                        dimension: _avatar,
                        child: KsNetImage(
                          url: me.photoUrl,
                          fallbackAsset: switch (me.role) {
                            UserRole.buyer => AppUi.avatarBuyer,
                            UserRole.transporter => AppUi.avatarDriver,
                            _ => AppUi.avatarFarmer,
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            me.name,
                            style: AppTypography.labelButton.normal.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            district.isEmpty
                                ? roleName
                                : l.roleDistrict(roleName, district),
                            style: AppTypography.caption.normal.withColor(
                              AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (me.isVerified)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.x10,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.bgBrand,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: Text(
                          l.verifiedBadge,
                          style: AppTypography.caption.normal.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textOnBrand,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x10),
                Row(
                  children: [
                    stat(_deals ? dealsText : l.notAvailable, statLabel),
                    const SizedBox(width: AppSpacing.x10),
                    stat(_deals ? onTime : l.notAvailable, l.statOnTime),
                  ],
                ),
                const SizedBox(height: AppSpacing.x10),
                Row(
                  children: [
                    stat(
                      _ratings ? rating : l.notAvailable,
                      l.statRatingReviews(
                        Fmt.digits(context, '${me.ratingCount}'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                    stat(since, l.memberLabel),
                  ],
                ),
                const SizedBox(height: AppSpacing.x10),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: Container(
                        color: AppColors.bgPage,
                        child: QrImageView(
                          data: summary,
                          size: _qr,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.shareCode(code),
                            style: AppTypography.bodySmallStrong.normal,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            l.shareVerifiedToday,
                            style: AppTypography.labelSmall.normal.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            l.shareQrNote,
                            style: AppTypography.labelSmall.normal.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md - 1),
          Text(l.whatToShow, style: AppTypography.bodyMediumEmphasis.normal),
          const SizedBox(height: AppSpacing.md - 1),
          toggle(l.showDeals, _deals, (v) => _deals = v),
          const SizedBox(height: AppSpacing.md - 1),
          toggle(l.showRatings, _ratings, (v) => _ratings = v),
          const SizedBox(height: AppSpacing.md - 1),
          toggle(l.showMoney, _money, (v) => _money = v),
          const SizedBox(height: AppSpacing.md - 1),
          Text(
            l.loanNote,
            style: AppTypography.caption.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              Expanded(
                child: KsButton.outline(
                  label: l.copyLink,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: summary));
                    if (context.mounted) KsToast.show(context, l.copied);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: KsButton(
                  label: l.shareNow,
                  onPressed: () =>
                      SharePlus.instance.share(ShareParams(text: summary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
