import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/presentation/simple_tabs.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_bottom_nav.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_home_header.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../farmer/data/listing_repository.dart';
import '../../farmer/domain/listing.dart';
import '../../farmer/presentation/listing_widgets.dart';
import '../../trade/data/trade_repository.dart';
import '../data/report_repository.dart';
import 'report_screens.dart';
import 'verify_screens.dart';

/// Moderator area (no Figma — built from HF components in the same theme).
/// Nav: Home · Listings · Reports · Verify · Profile.
class ModeratorShell extends StatefulWidget {
  const ModeratorShell({super.key});

  @override
  State<ModeratorShell> createState() => _ModeratorShellState();
}

class _ModeratorShellState extends State<ModeratorShell> {
  int _index = 0;
  ListingStatus _queueFilter = ListingStatus.pending;

  void _openQueue(ListingStatus s) => setState(() {
    _queueFilter = s;
    _index = 1;
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pages = [
      ModeratorHome(
        onOpenQueue: _openQueue,
        onOpenTab: (i) => setState(() => _index = i),
      ),
      ListingsQueue(
        filter: _queueFilter,
        onFilter: (s) => setState(() => _queueFilter = s),
      ),
      const ReportsQueue(),
      const VerificationQueue(),
      const SimpleProfileTab(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: KsBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          KsNavItem.svg(l.navHome, AppIcons.home),
          KsNavItem.svg(l.navListings, AppIcons.market),
          KsNavItem.svg(l.navReports, AppIcons.alert),
          KsNavItem.svg(l.navVerify, AppIcons.shield),
          KsNavItem.svg(l.navProfile, AppIcons.profile),
        ],
      ),
    );
  }
}

/// M1 Moderator Home: stat cards + pending queue preview.
class ModeratorHome extends ConsumerWidget {
  const ModeratorHome({super.key, required this.onOpenQueue, this.onOpenTab});
  final void Function(ListingStatus) onOpenQueue;
  final ValueChanged<int>? onOpenTab;

  static const _preview = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    String count(ListingStatus s) =>
        Fmt.digits(context, '${ref.watch(listingCountProvider(s)).value ?? 0}');
    final pending = ref.watch(listingsByStatusProvider(ListingStatus.pending));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsHomeHeader(
        name: me?.name ?? '',
        photoUrl: me?.photoUrl,
        onBell: () => context.push(Routes.notifications),
        onChat: () => context.push(Routes.messages),
        onAvatar: () {},
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.s2xl,
        ),
        children: [
          Row(
            children: [
              Expanded(
                child: KsStatCard(
                  label: l.modStatPending,
                  value: count(ListingStatus.pending),
                  onTap: () => onOpenQueue(ListingStatus.pending),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: KsStatCard(
                  label: l.modStatActive,
                  value: count(ListingStatus.active),
                  onTap: () => onOpenQueue(ListingStatus.active),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              Expanded(
                child: KsStatCard(
                  label: l.modStatHidden,
                  value: count(ListingStatus.hidden),
                  onTap: () => onOpenQueue(ListingStatus.hidden),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: KsStatCard(
                  label: l.modStatReports,
                  value: Fmt.digits(
                    context,
                    '${ref.watch(openReportsCountProvider).value ?? 0}',
                  ),
                  onTap: () => onOpenTab?.call(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          Row(
            children: [
              Expanded(
                child: KsStatCard(
                  label: l.modStatVerify,
                  value: Fmt.digits(
                    context,
                    '${ref.watch(pendingVerificationProvider).value?.length ?? 0}',
                  ),
                  onTap: () => onOpenTab?.call(3),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(
            title: l.modHomeQueue,
            actionLabel: l.commonSeeAll,
            onAction: () => onOpenQueue(ListingStatus.pending),
          ),
          const SizedBox(height: AppSpacing.block),
          ...pending.when(
            loading: () => [const KsSkeletonList(rows: 3, padded: false)],
            error: (_, _) => [Text(l.errorGeneric)],
            data: (list) => list.isEmpty
                ? [
                    Text(
                      l.modQueueEmpty,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                  ]
                : [
                    for (final x in list.take(_preview)) ...[
                      ListingTile(
                        listing: x,
                        subtitle:
                            '${x.farmerName} · '
                            '${l.listingSubtitle(Fmt.number(context, x.quantityKg), Fmt.number(context, x.pricePerKg))}',
                        onTap: () => context.push(Routes.moderatorReview(x.id)),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ],
          ),
        ],
      ),
    );
  }
}

/// M2 Listings Queue with status pills.
class ListingsQueue extends ConsumerWidget {
  const ListingsQueue({
    super.key,
    required this.filter,
    required this.onFilter,
    this.showBack = false,
  });
  final ListingStatus filter;
  final ValueChanged<ListingStatus> onFilter;
  final bool showBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(listingsByStatusProvider(filter));
    final pills = [
      (ListingStatus.pending, l.statusPending),
      (ListingStatus.active, l.statusActive),
      (ListingStatus.hidden, l.statusHidden),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.modListingsTitle, showBack: showBack),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final (s, label) in pills) ...[
                    if (s != ListingStatus.pending)
                      const SizedBox(width: AppSpacing.sm),
                    KsPill(
                      label: label,
                      selected: filter == s,
                      onTap: () => onFilter(s),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.block),
            Expanded(
              child: async.when(
                loading: () => const KsSkeletonList(padded: false),
                error: (_, _) => Center(child: Text(l.errorGeneric)),
                data: (list) => list.isEmpty
                    ? Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          l.emptyFilter,
                          style: AppTypography.bodyMedium.normal.withColor(
                            AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s2xl),
                        itemCount: list.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (_, i) => ListingTile(
                          listing: list[i],
                          subtitle: list[i].farmerName,
                          onTap: () =>
                              context.push(Routes.moderatorReview(list[i].id)),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// M2 as its own page (Admin → Moderation).
class ListingsQueuePage extends StatefulWidget {
  const ListingsQueuePage({super.key});

  @override
  State<ListingsQueuePage> createState() => _ListingsQueuePageState();
}

class _ListingsQueuePageState extends State<ListingsQueuePage> {
  ListingStatus _f = ListingStatus.pending;

  @override
  Widget build(BuildContext context) => ListingsQueue(
    filter: _f,
    onFilter: (s) => setState(() => _f = s),
    showBack: true,
  );
}

/// M3 Listing Review: listing like screen 23 + farmer + Approve / Reject.
class ListingReviewScreen extends ConsumerStatefulWidget {
  const ListingReviewScreen({super.key, required this.listingId});
  final String listingId;

  @override
  ConsumerState<ListingReviewScreen> createState() =>
      _ListingReviewScreenState();
}

class _ListingReviewScreenState extends ConsumerState<ListingReviewScreen> {
  static const _imageHeight = 160.0;
  bool _busy = false;

  Future<void> _approve() async {
    final l = AppLocalizations.of(context);
    final uid = ref.read(currentUserProvider).value?.uid;
    if (uid == null) return;
    setState(() => _busy = true);
    try {
      await ref.read(listingRepositoryProvider).approve(widget.listingId, uid);
      final x = ref.read(listingProvider(widget.listingId)).value;
      if (x != null) {
        await ref
            .read(tradeRepositoryProvider)
            .notify(
              toUid: x.farmerId,
              fromUid: uid,
              type: 'listing_approved',
              params: {'cropBn': x.cropNameBn, 'cropEn': x.cropNameEn},
              link: 'listing:${x.id}',
            );
      }
      if (!mounted) return;
      KsToast.show(context, l.modApproved);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorPermission);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _reject() async {
    final l = AppLocalizations.of(context);
    final uid = ref.read(currentUserProvider).value?.uid;
    if (uid == null) return;
    final note = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _RejectSheet(),
    );
    if (note == null || note.trim().isEmpty || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref
          .read(listingRepositoryProvider)
          .reject(widget.listingId, uid, note.trim());
      final x = ref.read(listingProvider(widget.listingId)).value;
      if (x != null) {
        await ref
            .read(tradeRepositoryProvider)
            .notify(
              toUid: x.farmerId,
              fromUid: uid,
              type: 'listing_rejected',
              params: {
                'cropBn': x.cropNameBn,
                'cropEn': x.cropNameEn,
                'note': note.trim(),
              },
              link: 'listing:${x.id}',
            );
      }
      if (!mounted) return;
      KsToast.show(context, l.modRejected);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorPermission);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(listingProvider(widget.listingId));
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.modReviewTitle),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text(l.errorGeneric)),
        data: (x) {
          if (x == null) return Center(child: Text(l.errorGeneric));
          final farmer = ref.watch(userByIdProvider(x.farmerId)).value;
          final (badge, bg, fg) = listingBadge(l, x.status);
          return SafeArea(
            top: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.contentTop,
                AppSpacing.screen,
                AppSpacing.lg,
              ),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: SizedBox(
                    height: _imageHeight,
                    child: KsNetImage(
                      url: x.photo,
                      fallbackAsset: CropCatalog.imageFor(x.cropKey),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.block),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l.cropWithGrade(x.cropName(lang), x.grade),
                        style: AppTypography.headingBold20.normal,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x10,
                        vertical: AppSpacing.badgeV,
                      ),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(AppRadius.badge),
                      ),
                      child: Text(
                        badge,
                        style: AppTypography.bodySmallEmphasis.normal.withColor(
                          fg,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.block),
                KsListItem(
                  thumb: KsNetImage(
                    url: farmer?.photoUrl,
                    fallbackAsset: AppUi.avatarFarmer,
                  ),
                  title: x.farmerName,
                  subtitle: [
                    l.modFarmer,
                    BdPlace.display(farmer?.location.district, lang),
                    farmer?.phone ?? '',
                  ].where((s) => s.isNotEmpty).join(' · '),
                  showChevron: false,
                ),
                const SizedBox(height: AppSpacing.block),
                KsInfoCard(
                  rows: [
                    (
                      l.fieldQuantity,
                      l.qtyKg(Fmt.number(context, x.quantityKg)),
                    ),
                    (
                      l.fieldPrice,
                      l.priceLine(Fmt.number(context, x.pricePerKg)),
                    ),
                    (
                      l.fieldAvailability,
                      l.availableFromDate(Fmt.date(context, x.availableFrom)),
                    ),
                    (
                      l.fieldPickup,
                      [
                        BdPlace.display(x.pickup.upazila, lang),
                        BdPlace.display(x.pickup.district, lang),
                      ].where((s) => s.isNotEmpty).join(', '),
                    ),
                  ],
                ),
                if (x.createdAt != null) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l.submittedOn(Fmt.date(context, x.createdAt!)),
                    style: AppTypography.caption.withColor(
                      AppColors.textSecondary,
                    ),
                  ),
                ],
                if ((x.moderationNote ?? '').isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(
                    l.moderationNote(x.moderationNote!),
                    style: AppTypography.bodySmall.withColor(
                      AppColors.textError,
                    ),
                  ),
                ],
                const SizedBox(
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
                ),
                Row(
                  children: [
                    if (x.status != ListingStatus.hidden)
                      Expanded(
                        child: KsButton.outline(
                          label: l.modReject,
                          onPressed: _busy ? null : _reject,
                        ),
                      ),
                    if (x.status != ListingStatus.hidden &&
                        x.status != ListingStatus.active)
                      const SizedBox(width: AppSpacing.md),
                    if (x.status != ListingStatus.active)
                      Expanded(
                        child: KsButton(
                          label: l.modApprove,
                          loading: _busy,
                          onPressed: _approve,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _RejectSheet extends StatefulWidget {
  const _RejectSheet();

  @override
  State<_RejectSheet> createState() => _RejectSheetState();
}

class _RejectSheetState extends State<_RejectSheet> {
  final _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s2xl,
        AppSpacing.screen,
        AppSpacing.screen + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          KsTextField(
            label: l.modRejectReasonTitle,
            hint: l.modRejectReasonHint,
            controller: _note,
            autofocus: true,
          ),
          const SizedBox(height: AppSpacing.block),
          KsButton(
            label: l.modReject,
            onPressed: () => Navigator.pop(context, _note.text),
          ),
        ],
      ),
    );
  }
}
