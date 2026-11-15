import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_option_card.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../transport/presentation/transport_common.dart';
import '../data/contract_repository.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;
const _grades = ['A', 'B', 'C'];

String _freq(AppLocalizations l, bool monthly) =>
    monthly ? l.freqMonthly : l.freqWeekly;

/// "অক্টো – ডিসে ২০২৬"
String contractRange(BuildContext context, DateTime a, DateTime b) {
  final lang = Localizations.localeOf(context).languageCode;
  final from = a.year == b.year
      ? DateFormat.MMM(lang).format(a)
      : DateFormat.yMMM(lang).format(a);
  return Fmt.digits(
    context,
    AppLocalizations.of(context)
        .dateRange(from, DateFormat.yMMM(lang).format(b)),
  );
}

String contractStatusLabel(AppLocalizations l, ContractStatus s, bool farmer) =>
    switch (s) {
      ContractStatus.pending => farmer ? l.contractNew : l.contractPending,
      ContractStatus.active => l.contractActive,
      ContractStatus.completed => l.contractDone,
      ContractStatus.rejected => l.contractRejected,
      ContractStatus.cancelled => l.contractCancelled,
    };

/// 38 Contracts (farmer, Figma 292:637) and 121 Contracts (buyer, 292:1402).
class ContractsScreen extends ConsumerStatefulWidget {
  const ContractsScreen({super.key});

  @override
  ConsumerState<ContractsScreen> createState() => _ContractsState();
}

class _ContractsState extends ConsumerState<ContractsScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final farmer = me?.role == UserRole.farmer;
    final async = ref.watch(myContractsProvider);
    // Farmer: নতুন · চলমান · সম্পন্ন. Buyer: চলমান · অপেক্ষমাণ · সম্পন্ন.
    final tabs = farmer
        ? [
            (l.contractNew, (Contract c) => c.status == ContractStatus.pending),
            (l.contractActive, (Contract c) => c.status == ContractStatus.active),
            (l.contractDone, (Contract c) => c.status.isClosed),
          ]
        : [
            (l.contractActive, (Contract c) => c.status == ContractStatus.active),
            (l.contractPending, (Contract c) => c.status == ContractStatus.pending),
            (l.contractDone, (Contract c) => c.status.isClosed),
          ];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.contractsTitle),
      bottomNavigationBar: farmer || me == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                    AppSpacing.sm, AppSpacing.screen, AppSpacing.lg),
                child: KsButton(
                  label: l.newContractBtn,
                  onPressed: () => context.push(Routes.newContract),
                ),
              ),
            ),
      body: switch (async) {
        AsyncData(:final value) => ListView(
            padding: _pad,
            children: [
              Wrap(spacing: AppSpacing.sm, children: [
                for (var i = 0; i < tabs.length; i++)
                  KsPill(
                    label: tabs[i].$1,
                    selected: _tab == i,
                    onTap: () => setState(() => _tab = i),
                  ),
              ]),
              ...() {
                final shown = value.where(tabs[_tab].$2).toList();
                if (shown.isEmpty) {
                  return [
                    const SizedBox(height: AppSpacing.block),
                    Text(l.contractsEmpty,
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.normal
                            .withColor(AppColors.textSecondary)),
                  ];
                }
                return [
                  for (final c in shown) ...[
                    const SizedBox(height: AppSpacing.block),
                    _ContractRow(c: c, farmer: farmer, lang: lang),
                  ],
                ];
              }(),
            ],
          ),
        AsyncError() => KsErrorState(
            onRetry: () => ref.invalidate(myContractsProvider)),
        _ => const KsSkeletonList(),
      },
    );
  }
}

class _ContractRow extends StatelessWidget {
  const _ContractRow({required this.c, required this.farmer, required this.lang});
  final Contract c;
  final bool farmer;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final status = contractStatusLabel(l, c.status, farmer);
    final pending = c.status == ContractStatus.pending && !farmer;
    final months = ContractRepository.termMonths;
    return KsListItem(
      thumb: farmer
          ? KsNetImage(
              url: c.buyerPhoto,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarBuyer,
            )
          : KsNetImage(
              url: null,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: CropCatalog.imageFor(c.cropKey),
            ),
      title: farmer
          ? c.buyerName
          : l.contractLine(c.cropName(lang), _freq(l, c.monthly),
              tonsText(context, c.quantityKg)),
      subtitle: farmer
          ? l.contractFarmerSub(_freq(l, c.monthly), c.cropName(lang),
              Fmt.digits(context, '$months'))
          : l.contractBuyerSub(
              c.farmerName, contractRange(context, c.start, c.end)),
      trailingText: pending ? null : status,
      badge: pending ? status : null,
      badgeColor: AppColors.bgWarningSubtle,
      badgeTextColor: AppColors.textWarning,
      onTap: () => context.push(
        farmer && c.status == ContractStatus.pending
            ? Routes.contractDetails(c.id)
            : Routes.contractStatus(c.id),
      ),
    );
  }
}

/// 39 Contract Details (farmer, Figma 292:650): accept or reject (D2).
class ContractDetailsScreen extends ConsumerStatefulWidget {
  const ContractDetailsScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ContractDetailsScreen> createState() =>
      _ContractDetailsState();
}

class _ContractDetailsState extends ConsumerState<ContractDetailsScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() f, String done) async {
    setState(() => _busy = true);
    try {
      await f();
      if (mounted) {
        KsToast.show(context, done);
        context.pop();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        KsToast.show(context, AppLocalizations.of(context).errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(contractProvider(widget.id));
    final repo = ref.read(contractRepositoryProvider);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.contractDetailsTitle),
      body: switch (async) {
        AsyncData(value: final c?) => ListView(
            padding: _pad,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.bgSuccessSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l.cropWithGrade(c.cropName(lang), c.grade),
                        style: AppTypography.headingBold20.normal),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                        c.buyerVerified
                            ? l.buyerVerifiedLine(c.buyerName)
                            : c.buyerName,
                        style: AppTypography.caption.normal
                            .withColor(AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                        l.contractPriceFixed(
                            Fmt.taka(context, c.pricePerKg)),
                        style: AppTypography.headingBold20.normal
                            .withColor(AppColors.textBrand)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.block),
              Text(l.contractTerms,
                  style: AppTypography.bodyMediumStrong.normal),
              const SizedBox(height: AppSpacing.block),
              KsInfoBox(children: [
                KsInfoRow(
                    l.fieldQuantity,
                    c.monthly
                        ? l.perMonthQty(qtyText(context, c.quantityKg))
                        : l.perWeekQty(qtyText(context, c.quantityKg))),
                KsInfoRow(l.rowTerm, contractRange(context, c.start, c.end)),
                KsInfoRow(l.fieldPickup, placeFull(context, c.pickup)),
                KsInfoRow(l.rowPayment, l.contractPayValue),
              ]),
              if (c.status == ContractStatus.pending) ...[
                const SizedBox(height: _gapBeforeCta),
                Row(children: [
                  Expanded(
                    child: KsButton.destructive(
                      label: l.reject,
                      onPressed: _busy
                          ? null
                          : () async {
                              final ok = await showKsConfirm(context,
                                  title: l.rejectContractQ,
                                  body: l.rejectContractBody,
                                  noLabel: l.noGoBack,
                                  yesLabel: l.yesReject);
                              if (ok) {
                                await _run(() => repo.reject(c),
                                    l.contractRejected);
                              }
                            },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: KsButton(
                      label: l.acceptContract,
                      loading: _busy,
                      onPressed: () =>
                          _run(() => repo.accept(c), l.contractAccepted),
                    ),
                  ),
                ]),
              ],
            ],
          ),
        AsyncData() => KsEmptyState(title: l.contractsEmpty, body: ''),
        AsyncError() => KsErrorState(
            onRetry: () => ref.invalidate(contractProvider(widget.id))),
        _ => const KsSkeletonList(),
      },
    );
  }
}

/// 122 Create Contract (buyer, Figma 292:1417).
class NewContractScreen extends ConsumerStatefulWidget {
  const NewContractScreen({super.key});

  @override
  ConsumerState<NewContractScreen> createState() => _NewContractState();
}

class _NewContractState extends ConsumerState<NewContractScreen> {
  AppUser? _farmer;
  Crop? _crop;
  String _grade = 'A';
  final _qty = TextEditingController();
  final _price = TextEditingController();
  bool _monthly = true;
  final Map<String, String?> _err = {};
  bool _busy = false;
  static const _optImg = 36.0;

  @override
  void dispose() {
    _qty.dispose();
    _price.dispose();
    super.dispose();
  }

  Future<void> _send(AppUser me) async {
    final l = AppLocalizations.of(context);
    final q = num.tryParse(Fmt.latinDigits(_qty.text.trim())) ?? 0;
    final p = num.tryParse(Fmt.latinDigits(_price.text.trim())) ?? 0;
    setState(() {
      _err
        ..clear()
        ..['farmer'] = _farmer == null ? l.errSelectSupplier : null
        ..['crop'] = _crop == null ? l.errSelectCrop : null
        ..['qty'] = q <= 0 ? l.errQtyInvalid : null
        ..['price'] = p <= 0 ? l.errPriceInvalid : null;
    });
    if (_err.values.any((e) => e != null)) return;
    setState(() => _busy = true);
    try {
      final id = await ref.read(contractRepositoryProvider).create(
            buyer: me,
            farmer: _farmer!,
            cropKey: _crop!.key,
            cropNameBn: _crop!.bn,
            cropNameEn: _crop!.en,
            grade: _grade,
            quantityKg: q,
            pricePerKg: p,
            monthly: _monthly,
          );
      if (!mounted) return;
      KsToast.show(context, l.contractSent);
      context.pushReplacement(Routes.contractStatus(id));
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        KsToast.show(context, l.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final farmers = ref.watch(farmersProvider).value ?? const <AppUser>[];
    final crops = ref.watch(catalogProvider).where((c) => c.active).toList();
    final digits = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))];
    final plan = ContractRepository.plan(true, DateTime.now());

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.newContractTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsSelectField(
            label: l.fieldSupplier,
            placeholder: l.selectHint,
            value: _farmer?.name,
            errorText: _err['farmer'],
            onTap: () async {
              final f = await showKsOptionsSheet<AppUser>(
                context,
                title: l.fieldSupplier,
                searchHint: l.searchFarmerHint,
                options: [
                  for (final f in farmers)
                    if (f.uid != me?.uid)
                      (
                        f,
                        districtOf(context, f.location).isEmpty
                            ? f.name
                            : '${f.name} · ${districtOf(context, f.location)}'
                      ),
                ],
              );
              if (f != null) setState(() => _farmer = f);
            },
          ),
          const SizedBox(height: AppSpacing.block),
          KsSelectField(
            label: l.fieldCropGrade,
            placeholder: l.selectHint,
            value: _crop == null
                ? null
                : l.cropGradeValue(_crop!.name(lang), _grade),
            errorText: _err['crop'],
            onTap: () async {
              final c = await showKsOptionsSheet<Crop>(
                context,
                title: l.fieldCropName,
                options: [for (final c in crops) (c.crop, c.crop.name(lang))],
              );
              if (c == null || !context.mounted) return;
              final g = await showKsOptionsSheet<String>(
                context,
                title: l.fieldGradeSize,
                options: [for (final g in _grades) (g, l.gradeLabel(g))],
              );
              setState(() {
                _crop = c;
                if (g != null) _grade = g;
              });
            },
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.fieldQtyPerDelivery,
            hint: Fmt.digits(context, '2000'),
            controller: _qty,
            suffixText: l.unitKg,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            errorText: _err['qty'],
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.fieldFixedPrice,
            hint: Fmt.digits(context, '30'),
            controller: _price,
            suffixText: l.sellPriceUnit,
            keyboardType: TextInputType.number,
            inputFormatters: digits,
            errorText: _err['price'],
          ),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppImages.langIcon),
            imageSize: _optImg,
            title: l.freqMonthly,
            subtitle: contractRange(context, plan.first, plan.last),
            selected: _monthly,
            onTap: () => setState(() => _monthly = true),
          ),
          const SizedBox(height: AppSpacing.block),
          KsOptionCard(
            image: const AssetImage(AppImages.langIcon),
            imageSize: _optImg,
            title: l.freqWeekly,
            selected: !_monthly,
            onTap: () => setState(() => _monthly = false),
          ),
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.sendContract,
            loading: _busy,
            onPressed: me == null ? null : () => _send(me),
          ),
        ],
      ),
    );
  }
}

/// 123 Contract Status (Figma 292:1438): terms, delivery schedule, cancel
/// (D3) and renew. The buyer turns each planned delivery into an order.
class ContractStatusScreen extends ConsumerStatefulWidget {
  const ContractStatusScreen({super.key, required this.id});
  final String id;

  @override
  ConsumerState<ContractStatusScreen> createState() => _ContractStatusState();
}

class _ContractStatusState extends ConsumerState<ContractStatusScreen> {
  bool _busy = false;

  Future<void> _orderDelivery(Contract c, int i, AppUser me) async {
    final l = AppLocalizations.of(context);
    final ok = await showKsConfirm(context,
        title: l.orderDeliveryQ,
        body: l.orderDeliveryBody(qtyText(context, c.quantityKg),
            Fmt.taka(context, c.quantityKg * c.pricePerKg)),
        noLabel: l.noGoBack,
        yesLabel: l.orderNow,
        positive: true);
    if (!ok || !mounted) return;
    setState(() => _busy = true);
    try {
      final orderId =
          await ref.read(contractRepositoryProvider).orderDelivery(c, i, me);
      if (mounted) context.push(Routes.order(orderId));
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel(Contract c, AppUser me) async {
    final l = AppLocalizations.of(context);
    final ok = await showKsConfirm(context,
        title: l.cancelContractQ,
        body: l.cancelContractBody,
        noLabel: l.noGoBack,
        yesLabel: l.yesCancelIt);
    if (!ok) return;
    setState(() => _busy = true);
    try {
      await ref.read(contractRepositoryProvider).cancel(c, me.uid);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _renew(Contract c, AppUser me) async {
    final l = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final farmer =
          await ref.read(userRepositoryProvider).watchUser(c.farmerId).first;
      if (farmer == null) throw Exception('farmer');
      final id =
          await ref.read(contractRepositoryProvider).renew(c, me, farmer);
      if (!mounted) return;
      KsToast.show(context, l.contractRenewed);
      context.pushReplacement(Routes.contractStatus(id));
    } catch (_) {
      if (mounted) {
        setState(() => _busy = false);
        KsToast.show(context, l.errorGeneric);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(contractProvider(widget.id));
    // A farmer opening a new contract (e.g. from a notification) sees 39.
    final c0 = async.value;
    if (c0 != null &&
        me?.uid == c0.farmerId &&
        c0.status == ContractStatus.pending) {
      return ContractDetailsScreen(id: widget.id);
    }
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.contractStatusTitle),
      body: switch (async) {
        AsyncData(value: final c?) when me != null => () {
            final buyer = me.uid == c.buyerId;
            final open = !c.status.isClosed;
            // Only the next planned delivery can be ordered, in order.
            final next = c.schedule.indexWhere((d) => d.orderId == null);
            return ListView(
              padding: _pad,
              children: [
                KsInfoBox(children: [
                  KsInfoRow(
                      l.rowContract,
                      l.contractLine(c.cropName(lang), _freq(l, c.monthly),
                          tonsText(context, c.quantityKg))),
                  KsInfoRow(buyer ? l.rowSupplier : l.rowBuyerLabel,
                      buyer ? c.farmerName : c.buyerName),
                  KsInfoRow(l.rowPrice,
                      l.priceLine(Fmt.number(context, c.pricePerKg))),
                  KsInfoRow(
                      l.rowTerm, contractRange(context, c.start, c.end)),
                  if (c.status != ContractStatus.active)
                    KsInfoRow(l.rowStatus,
                        contractStatusLabel(l, c.status, !buyer)),
                ]),
                const SizedBox(height: AppSpacing.block),
                Text(l.deliverySchedule,
                    style: AppTypography.bodyMediumStrong.normal),
                for (var i = 0; i < c.schedule.length; i++) ...[
                  const SizedBox(height: AppSpacing.block),
                  KsTimelineItem(
                    title: c.monthly
                        ? l.monthDelivery(
                            DateFormat.MMMM(lang).format(c.schedule[i].due))
                        : l.weekDelivery(Fmt.digits(context, '${i + 1}')),
                    subtitle: c.schedule[i].orderId != null
                        ? l.deliveryOrdered(qtyText(context, c.quantityKg))
                        : l.deliveryDue(Fmt.date(context, c.schedule[i].due)),
                    done: c.schedule[i].orderId != null,
                    onTap: c.schedule[i].orderId != null
                        ? () => context
                            .push(Routes.order(c.schedule[i].orderId!))
                        : (buyer &&
                                c.status == ContractStatus.active &&
                                i == next &&
                                !_busy)
                            ? () => _orderDelivery(c, i, me)
                            : null,
                  ),
                ],
                const SizedBox(height: _gapBeforeCta),
                // Renew once the farmer has agreed (not while pending).
                if (buyer && c.status != ContractStatus.pending)
                  Row(children: [
                    if (open) ...[
                      Expanded(
                        child: KsButton.destructive(
                          label: l.cancelContract,
                          onPressed: _busy ? null : () => _cancel(c, me),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                    ],
                    Expanded(
                      child: KsButton(
                        label: l.renewContract,
                        loading: _busy,
                        onPressed: () => _renew(c, me),
                      ),
                    ),
                  ])
                else if (open)
                  KsButton.destructive(
                    label: l.cancelContract,
                    onPressed: _busy ? null : () => _cancel(c, me),
                  ),
              ],
            );
          }(),
        AsyncData() => KsEmptyState(title: l.contractsEmpty, body: ''),
        AsyncError() => KsErrorState(
            onRetry: () => ref.invalidate(contractProvider(widget.id))),
        _ => const KsSkeletonList(),
      },
    );
  }
}
