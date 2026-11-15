import 'package:flutter/services.dart';
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
import '../../../shared/data/market_price_repository.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/presentation/simple_tabs.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_bottom_nav.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_home_header.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../farmer/data/listing_repository.dart';
import '../../farmer/domain/listing.dart';
import '../../moderator/data/report_repository.dart';
import '../../moderator/presentation/report_screens.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/admin_repository.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.s2xl,
);

String _n(BuildContext c, int v) => Fmt.digits(c, '$v');

/// Admin area (no Figma — HF components, same theme).
/// Nav: Home · Users · Moderation · Prices · Profile (A1–A7).
class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pages = [
      AdminDashboard(onTab: (i) => setState(() => _index = i)),
      const UsersScreen(),
      const ModerationHub(),
      const PricesScreen(),
      const SimpleProfileTab(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: KsBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          KsNavItem.svg(l.navHome, AppIcons.home),
          KsNavItem.svg(l.navUsers, AppIcons.profile),
          KsNavItem.svg(l.navModeration, AppIcons.shield),
          KsNavItem.svg(l.navPrices, AppIcons.trendUp),
          KsNavItem.svg(l.navProfile, AppIcons.profile),
        ],
      ),
    );
  }
}

/// A1 Admin Dashboard: real totals (count queries). Pull to refresh.
class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key, required this.onTab});
  final ValueChanged<int> onTab;

  Widget _row(List<Widget> cards) => Row(
    children: [
      for (var i = 0; i < cards.length; i++) ...[
        if (i > 0) const SizedBox(width: AppSpacing.lg),
        Expanded(child: cards[i]),
      ],
    ],
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(adminStatsProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsHomeHeader(
        name: me?.name ?? '',
        photoUrl: me?.photoUrl,
        onBell: () => context.push(Routes.notifications),
        onChat: () => context.push(Routes.messages),
        onAvatar: () => onTab(4),
      ),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () => ref.invalidate(adminStatsProvider),
        ),
        AsyncData(value: final s) => RefreshIndicator(
          onRefresh: () => ref.refresh(adminStatsProvider.future),
          child: ListView(
            padding: _pad,
            children: [
              KsSectionHeader(title: l.adminUsersSection),
              const SizedBox(height: AppSpacing.block),
              _row([
                KsStatCard(
                  label: l.statTotalUsers,
                  value: _n(context, s.totalUsers),
                  onTap: () => onTab(1),
                ),
                KsStatCard(
                  label: l.roleFarmer,
                  value: _n(context, s.byRole[UserRole.farmer] ?? 0),
                  onTap: () => onTab(1),
                ),
              ]),
              const SizedBox(height: AppSpacing.block),
              _row([
                KsStatCard(
                  label: l.roleBuyer,
                  value: _n(context, s.byRole[UserRole.buyer] ?? 0),
                  onTap: () => onTab(1),
                ),
                KsStatCard(
                  label: l.roleTransporter,
                  value: _n(context, s.byRole[UserRole.transporter] ?? 0),
                  onTap: () => onTab(1),
                ),
              ]),
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(title: l.adminListingsSection),
              const SizedBox(height: AppSpacing.block),
              _row([
                KsStatCard(
                  label: l.modStatActive,
                  value: _n(context, s.activeListings),
                  onTap: () => context.push(Routes.moderatorQueue),
                ),
                KsStatCard(
                  label: l.modStatPending,
                  value: _n(context, s.pendingListings),
                  onTap: () => context.push(Routes.moderatorQueue),
                ),
              ]),
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(title: l.adminOrdersSection),
              const SizedBox(height: AppSpacing.block),
              _row([
                KsStatCard(
                  label: l.statOngoingOrders,
                  value: _n(context, s.ongoingOrders),
                ),
                KsStatCard(
                  label: l.statCompletedOrders,
                  value: _n(context, s.completedOrders),
                ),
              ]),
              const SizedBox(height: AppSpacing.block),
              _row([
                KsStatCard(
                  label: l.modStatReports,
                  value: _n(context, s.openReports),
                  onTap: () => context.push(Routes.moderatorReports),
                ),
                KsStatCard(
                  label: l.modStatVerify,
                  value: _n(context, s.pendingVerifications),
                  onTap: () => context.push(Routes.moderatorVerify),
                ),
              ]),
              const SizedBox(height: AppSpacing.block),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: KsActionTile(
                      primary: true,
                      icon: AppUi.glyphTrendUp,
                      title: l.pricesTitle,
                      hint: l.pricesSub,
                      onTap: () => onTab(3),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: KsActionTile(
                      icon: AppUi.glyphLeaf,
                      title: l.cropsTitle,
                      hint: l.cropsSub,
                      onTap: () => context.push(Routes.adminCrops),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        _ => const KsSkeletonHome(),
      },
    );
  }
}

/// A2 Users: search by name / phone, filter by role.
class UsersScreen extends ConsumerStatefulWidget {
  const UsersScreen({super.key});

  @override
  ConsumerState<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends ConsumerState<UsersScreen> {
  final _q = TextEditingController();
  UserRole? _role;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  bool _match(AppUser u) {
    if (_role != null && u.role != _role) return false;
    final q = Fmt.latinDigits(_q.text.trim().toLowerCase());
    if (q.isEmpty) return true;
    return u.name.toLowerCase().contains(q) || u.phone.contains(q);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(allUsersProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.usersTitle, showBack: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentTop,
              AppSpacing.screen,
              0,
            ),
            child: Column(
              children: [
                KsSearchBar(
                  hint: l.userSearchHint,
                  controller: _q,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.block),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final (r, label) in [
                        (null, l.filterAll),
                        (UserRole.farmer, l.roleFarmer),
                        (UserRole.buyer, l.roleBuyer),
                        (UserRole.transporter, l.roleTransporter),
                        (UserRole.moderator, l.roleModerator),
                        (UserRole.admin, l.roleAdmin),
                      ]) ...[
                        KsPill(
                          label: label,
                          selected: _role == r,
                          onTap: () => setState(() => _role = r),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (async) {
              AsyncError(:final error) => KsErrorState.from(
                error,
                onRetry: () => ref.invalidate(allUsersProvider),
              ),
              AsyncData(value: final all) => () {
                final list = all.where(_match).toList();
                return ListView(
                  padding: _pad,
                  children: [
                    if (list.isEmpty)
                      Text(
                        l.noUsers,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.normal.withColor(
                          AppColors.textSecondary,
                        ),
                      ),
                    for (final u in list) ...[
                      KsListItem(
                        thumb: KsNetImage(
                          url: u.photoUrl,
                          thumbSize: KsListItem.thumbSize.round(),
                          fallbackAsset: avatarFor(u.role?.name),
                        ),
                        title: u.name.isEmpty ? u.phone : u.name,
                        subtitle: l.nameRolePhone(
                          roleLabel(l, u.role?.name),
                          u.phone,
                        ),
                        badge: u.isSuspended ? l.suspendedBadge : null,
                        badgeColor: AppColors.bgErrorSubtle,
                        badgeTextColor: AppColors.textError,
                        onTap: () {
                            // Don't reopen the keyboard when coming back.
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.push(Routes.adminUser(u.uid));
                          },
                      ),
                      const SizedBox(height: AppSpacing.block),
                    ],
                  ],
                );
              }(),
              _ => const KsSkeletonList(),
            },
          ),
        ],
      ),
    );
  }
}

/// A3 User Detail: facts + Suspend/Activate + change role.
class UserDetailScreen extends ConsumerStatefulWidget {
  const UserDetailScreen({super.key, required this.uid});
  final String uid;

  @override
  ConsumerState<UserDetailScreen> createState() => _UserDetailState();
}

class _UserDetailState extends ConsumerState<UserDetailScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() f, String done) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await f();
      if (mounted) KsToast.show(context, done);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final u = ref.watch(userByIdProvider(widget.uid)).value;
    if (u == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.userDetailTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final repo = ref.read(adminRepositoryProvider);
    final self = u.uid == me.uid;
    final verification = switch (u.verification) {
      VerificationStatus.none => l.vNone,
      VerificationStatus.pending => l.vPending,
      VerificationStatus.verified => l.vVerified,
      VerificationStatus.rejected => l.vRejected,
    };

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.userDetailTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: u.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: avatarFor(u.role?.name),
            ),
            title: u.name.isEmpty ? u.phone : u.name,
            subtitle: roleLabel(l, u.role?.name),
            badge: u.isSuspended ? l.suspendedBadge : null,
            badgeColor: AppColors.bgErrorSubtle,
            badgeTextColor: AppColors.textError,
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.profilePhone, u.phone),
              if (u.location.isComplete)
                KsInfoRow(l.fieldLocation, placeFull(context, u.location)),
              KsInfoRow(
                l.rowOfferStatus,
                u.isSuspended ? l.suspendedBadge : l.statusActiveUser,
              ),
              KsInfoRow(l.rowVerification, verification),
              if ((u.nidNumber ?? '').isNotEmpty)
                KsInfoRow(l.rowNid, u.nidNumber!),
              KsInfoRow(
                l.rowRating,
                u.ratingCount == 0
                    ? l.notAvailable
                    : l.ratingLine(
                        Fmt.number(context, u.ratingAvg, decimals: 1),
                        _n(context, u.ratingCount),
                      ),
              ),
              if (u.createdAt != null)
                KsInfoRow(l.rowJoined, Fmt.date(context, u.createdAt!)),
            ],
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          if (self)
            KsNoteBox(title: l.cantEditSelf)
          else ...[
            KsButton.secondary(
              label: l.changeRole,
              onPressed: _busy
                  ? null
                  : () async {
                      final r = await showKsOptionsSheet<UserRole>(
                        context,
                        title: l.changeRole,
                        options: [
                          for (final r in UserRole.values)
                            (r, roleLabel(l, r.name)),
                        ],
                      );
                      if (r != null && r != u.role) {
                        await _run(() => repo.setRole(u.uid, r), l.roleChanged);
                      }
                    },
            ),
            const SizedBox(height: AppSpacing.block),
            if (u.isSuspended)
              KsButton(
                label: l.activateUser,
                loading: _busy,
                onPressed: () => _run(
                  () => repo.setStatus(u.uid, UserStatus.active),
                  l.doneToast,
                ),
              )
            else
              KsButton.destructive(
                label: l.suspendUser,
                loading: _busy,
                onPressed: () async {
                  final ok = await showKsConfirm(
                    context,
                    title: l.suspendTitle,
                    body: l.suspendBody,
                    noLabel: l.commonCancel,
                    yesLabel: l.suspendUser,
                  );
                  if (ok) {
                    await _run(
                      () => repo.setStatus(u.uid, UserStatus.suspended),
                      l.doneToast,
                    );
                  }
                },
              ),
          ],
        ],
      ),
    );
  }
}

/// A4 Moderation hub: opens the moderator tools (M2–M6).
class ModerationHub extends ConsumerWidget {
  const ModerationHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final pending = ref
        .watch(listingCountProvider(ListingStatus.pending))
        .value;
    final reports = ref.watch(openReportsCountProvider).value;
    final verify = ref.watch(pendingVerificationProvider).value?.length;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.moderationTitle, showBack: false),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            title: l.modListingsTitle,
            subtitle: l.placeDate(l.modStatPending, _n(context, pending ?? 0)),
            onTap: () => context.push(Routes.moderatorQueue),
          ),
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            title: l.modReportsTitle,
            subtitle: l.placeDate(l.modStatReports, _n(context, reports ?? 0)),
            onTap: () => context.push(Routes.moderatorReports),
          ),
          const SizedBox(height: AppSpacing.block),
          KsListItem(
            title: l.verifyTitle,
            subtitle: l.placeDate(l.modStatVerify, _n(context, verify ?? 0)),
            onTap: () => context.push(Routes.moderatorVerify),
          ),
        ],
      ),
    );
  }
}

/// A5 Market Prices manager (feeds 15/71 price cards and 23/75 ranges).
class PricesScreen extends ConsumerWidget {
  const PricesScreen({super.key});

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    Crop crop,
    MarketPrice? old,
  ) async {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    String fmt(num? v) => v == null ? '' : '$v';
    final price = TextEditingController(text: fmt(old?.price));
    final min = TextEditingController(text: fmt(old?.min));
    final max = TextEditingController(text: fmt(old?.max));
    String? err;
    // Day of the price: today by default; past days fill the trend (30).
    var day = DateTime.now();
    final digits = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))];
    num? parse(TextEditingController c) =>
        num.tryParse(Fmt.latinDigits(c.text.trim()));

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.lg + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(crop.name(lang), style: AppTypography.h3.normal),
                  ),
                  KsPill(
                    label: Fmt.date(ctx, day),
                    selected: true,
                    onTap: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      final now = DateTime.now();
                      final d = await showDatePicker(
                        context: ctx,
                        firstDate: now.subtract(const Duration(days: 90)),
                        lastDate: now,
                        initialDate: day,
                      );
                      if (d != null) setS(() => day = d);
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              KsTextField(
                label: l.fieldTodayPrice,
                hint: '',
                controller: price,
                suffixText: l.sellPriceUnit,
                keyboardType: TextInputType.number,
                inputFormatters: digits,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: KsTextField(
                      label: l.fieldMinPrice,
                      hint: '',
                      controller: min,
                      keyboardType: TextInputType.number,
                      inputFormatters: digits,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: KsTextField(
                      label: l.fieldMaxPrice,
                      hint: '',
                      controller: max,
                      keyboardType: TextInputType.number,
                      inputFormatters: digits,
                      errorText: err,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.block),
              KsButton(
                label: l.commonSave,
                onPressed: () async {
                  final p = parse(price), lo = parse(min), hi = parse(max);
                  if (p == null ||
                      lo == null ||
                      hi == null ||
                      lo > p ||
                      p > hi) {
                    setS(() => err = l.errPriceRange);
                    return;
                  }
                  try {
                    await ref
                        .read(marketPriceRepositoryProvider)
                        .set(
                          crop.key,
                          price: p,
                          min: lo,
                          max: hi,
                          day: day,
                          prevPrice: old?.price ?? p,
                          cropBn: crop.bn,
                          cropEn: crop.en,
                          fromUid:
                              ref.read(currentUserProvider).value?.uid ?? '',
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) KsToast.show(context, l.priceSaved);
                  } catch (_) {
                    if (context.mounted) KsToast.show(context, l.errorGeneric);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    price.dispose();
    min.dispose();
    max.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final prices = {
      for (final p
          in ref.watch(marketPricesProvider).value ?? const <MarketPrice>[])
        p.cropKey: p,
    };
    final crops = ref
        .watch(catalogProvider)
        .where((c) => c.active)
        .map((c) => c.crop);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.pricesTitle, showBack: false),
      body: ListView(
        padding: _pad,
        children: [
          for (final c in crops) ...[
            KsListItem(
              thumb: c.image == null
                  ? null
                  : Image.asset(c.image!, fit: BoxFit.cover),
              title: c.name(lang),
              subtitle: prices[c.key] == null
                  ? l.noPrice
                  : l.priceSub(
                      Fmt.number(context, prices[c.key]!.price),
                      Fmt.number(context, prices[c.key]!.min),
                      Fmt.number(context, prices[c.key]!.max),
                    ),
              onTap: () => _edit(context, ref, c, prices[c.key]),
            ),
            const SizedBox(height: AppSpacing.block),
          ],
        ],
      ),
    );
  }
}

/// A6 Crop Catalog: turn crops on/off for Sell Crop, add new ones.
class CropCatalogScreen extends ConsumerWidget {
  const CropCatalogScreen({super.key});

  static String _catLabel(AppLocalizations l, CropCategory c) => switch (c) {
    CropCategory.vegetable => l.catVegetable,
    CropCategory.fruit => l.catFruit,
    CropCategory.grain => l.catGrain,
    CropCategory.fish => l.catFish,
    CropCategory.spice => l.catSpice,
    CropCategory.pulse => l.catPulse,
    CropCategory.other => l.catOther,
  };

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final bn = TextEditingController();
    final en = TextEditingController();
    var cat = CropCategory.vegetable;
    String? err;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.lg,
            AppSpacing.screen,
            AppSpacing.lg + MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l.addCrop, style: AppTypography.h3.normal),
              const SizedBox(height: AppSpacing.md),
              KsTextField(label: l.cropNameBn, hint: '', controller: bn),
              const SizedBox(height: AppSpacing.md),
              KsTextField(
                label: l.cropNameEn,
                hint: '',
                controller: en,
                errorText: err,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l.cropCategory,
                style: AppTypography.bodyMediumEmphasis.normal,
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final c in CropCategory.values)
                    KsPill(
                      label: _catLabel(l, c),
                      selected: cat == c,
                      onTap: () => setS(() => cat = c),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.block),
              KsButton(
                label: l.commonSave,
                onPressed: () async {
                  final key = en.text
                      .trim()
                      .toLowerCase()
                      .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
                      .replaceAll(RegExp(r'^_+|_+$'), '');
                  if (bn.text.trim().isEmpty || key.isEmpty) {
                    setS(() => err = l.commonRequired);
                    return;
                  }
                  try {
                    await ref
                        .read(adminRepositoryProvider)
                        .saveCrop(
                          CropDoc(
                            key: key,
                            bn: bn.text.trim(),
                            en: en.text.trim(),
                            category: cat,
                            active: true,
                          ),
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                    if (context.mounted) KsToast.show(context, l.cropSaved);
                  } catch (_) {
                    if (context.mounted) KsToast.show(context, l.errorGeneric);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
    bn.dispose();
    en.dispose();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = ref.watch(catalogProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.cropsTitle),
      body: ListView(
        padding: _pad,
        children: [
          for (final c in all) ...[
            KsListItem(
              thumb: c.crop.image == null
                  ? null
                  : Image.asset(c.crop.image!, fit: BoxFit.cover),
              title: c.crop.name(lang),
              subtitle: c.custom
                  ? l.placeDate(_catLabel(l, c.crop.category), l.customCrop)
                  : _catLabel(l, c.crop.category),
              showChevron: false,
              trailing: KsPill(
                label: c.active ? l.cropOn : l.cropOff,
                selected: c.active,
                onTap: () => ref
                    .read(adminRepositoryProvider)
                    .saveCrop(
                      CropDoc(
                        key: c.crop.key,
                        bn: c.crop.bn,
                        en: c.crop.en,
                        category: c.crop.category,
                        active: !c.active,
                      ),
                    ),
              ),
            ),
            const SizedBox(height: AppSpacing.block),
          ],
          KsButton.secondary(
            label: l.addCrop,
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
    );
  }
}
