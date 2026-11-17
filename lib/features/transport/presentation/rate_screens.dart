import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../auth/data/user_repository.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../data/transport_repository.dart';

/// Stars + tag pills block shared by 111 and 169.
class _RateBlock extends StatelessWidget {
  const _RateBlock({
    required this.stars,
    required this.onStars,
    this.tags = const [],
    this.selected = const {},
    this.onTag,
  });

  final int stars;
  final ValueChanged<int> onStars;
  final List<(String, String)> tags; // (key, label)
  final Set<String> selected;
  final ValueChanged<String>? onTag;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsStarRating(value: stars, onChanged: onStars),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.block),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (k, label) in tags)
                KsPill(
                  label: label,
                  selected: selected.contains(k),
                  onTap: () => onTag?.call(k),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

Widget _person(String title, String sub, String? photo, String fallback) =>
    KsListItem(
      thumb: KsNetImage(
        url: photo,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: fallback,
      ),
      title: title,
      subtitle: sub,
      showChevron: false,
    );

Set<String> _toggle(Set<String> s, String k) =>
    s.contains(k) ? ({...s}..remove(k)) : {...s, k};

/// 111 Rate & Review (buyer, Figma 292:1322): farmer + driver.
/// Submitting completes the order.
class RateOrderScreen extends ConsumerStatefulWidget {
  const RateOrderScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<RateOrderScreen> createState() => _RateOrderState();
}

class _RateOrderState extends ConsumerState<RateOrderScreen> {
  int _farmerStars = 0;
  int _driverStars = 0;
  Set<String> _tags = {};
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit(TradeOrder o, String myUid) async {
    final l = AppLocalizations.of(context);
    final hasDriver = o.transporterId != null;
    if (_farmerStars == 0 || (hasDriver && _driverStars == 0)) {
      KsToast.show(context, l.errPickStars);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(transportRepositoryProvider)
          .submitReviews(
            orderId: o.id,
            fromUid: myUid,
            comment: _comment.text.trim(),
            completeOrder: true,
            reviews: [
              ReviewInput(
                toUid: o.farmerId,
                toRole: 'farmer',
                stars: _farmerStars,
                tags: _tags.toList(),
              ),
              if (hasDriver)
                ReviewInput(
                  toUid: o.transporterId!,
                  toRole: 'transporter',
                  stars: _driverStars,
                ),
            ],
          );
      if (!mounted) return;
      KsToast.show(context, l.ratingThanks);
      context.pop();
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
    final o = ref.watch(orderProvider(widget.orderId)).value;
    if (o == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.rateTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final farmer = ref.watch(userByIdProvider(o.farmerId)).value;
    final driver = o.transporterId == null
        ? null
        : ref.watch(userByIdProvider(o.transporterId!)).value;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.rateTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          _person(
            l.roleFarmerName(o.farmerName),
            o.orderNo,
            farmer?.photoUrl,
            AppUi.avatarFarmer,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.howWasSupplier,
            textAlign: TextAlign.center,
            style: AppTypography.bold18.normal,
          ),
          const SizedBox(height: AppSpacing.block),
          _RateBlock(
            stars: _farmerStars,
            onStars: (v) => setState(() => _farmerStars = v),
            tags: [
              ('good_quality', l.tagGoodQuality),
              ('right_weight', l.tagRightWeight),
              ('on_time', l.tagOnTime),
            ],
            selected: _tags,
            onTag: (k) => setState(() => _tags = _toggle(_tags, k)),
          ),
          if (o.transporterId != null) ...[
            const SizedBox(height: AppSpacing.block),
            _person(
              l.roleDriver(o.transporterName ?? ''),
              l.rateTransport,
              driver?.photoUrl,
              AppUi.avatarDriver,
            ),
            const SizedBox(height: AppSpacing.block),
            _RateBlock(
              stars: _driverStars,
              onStars: (v) => setState(() => _driverStars = v),
            ),
          ],
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.commentOptional,
            hint: l.commentHint,
            controller: _comment,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.submit,
            loading: _busy,
            onPressed: () => _submit(o, me.uid),
          ),
        ],
      ),
    );
  }
}

/// 169 Rate & Review (transporter → customer, Figma 292:1820).
class RateCustomerScreen extends ConsumerStatefulWidget {
  const RateCustomerScreen({super.key, required this.deliveryId});
  final String deliveryId;

  @override
  ConsumerState<RateCustomerScreen> createState() => _RateCustomerState();
}

class _RateCustomerState extends ConsumerState<RateCustomerScreen> {
  int _stars = 0;
  Set<String> _tags = {};
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final d = ref.watch(deliveryProvider(widget.deliveryId)).value;
    if (d == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.rateTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final buyer = ref.watch(userByIdProvider(d.buyerId)).value;

    Future<void> submit() async {
      if (_stars == 0) {
        KsToast.show(context, l.errPickStars);
        return;
      }
      setState(() => _busy = true);
      try {
        await ref
            .read(transportRepositoryProvider)
            .submitReviews(
              orderId: d.orderId,
              fromUid: me.uid,
              comment: _comment.text.trim(),
              ratedDeliveryId: d.id,
              reviews: [
                ReviewInput(
                  toUid: d.buyerId,
                  toRole: 'buyer',
                  stars: _stars,
                  tags: _tags.toList(),
                ),
              ],
            );
        if (!mounted) return;
        KsToast.show(this.context, l.ratingThanks);
        this.context.pop();
      } catch (_) {
        if (mounted) KsToast.show(this.context, l.errorGeneric);
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.rateTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          _person(
            l.roleCustomer(d.buyerName),
            l.justFinishedTrip,
            buyer?.photoUrl,
            AppUi.avatarBuyer,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.howWasCustomer,
            textAlign: TextAlign.center,
            style: AppTypography.bold18.normal,
          ),
          const SizedBox(height: AppSpacing.block),
          _RateBlock(
            stars: _stars,
            onStars: (v) => setState(() => _stars = v),
            tags: [
              ('on_time_load', l.tagOnTimeLoad),
              ('correct_info', l.tagCorrectInfo),
              ('fast_pay', l.tagFastPay),
            ],
            selected: _tags,
            onTag: (k) => setState(() => _tags = _toggle(_tags, k)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.commentOptional,
            hint: l.commentHint,
            controller: _comment,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(label: l.submit, loading: _busy, onPressed: submit),
        ],
      ),
    );
  }
}

/// Has [from] already rated [to] for this order? (key: orderId|from|to)
final reviewedProvider = FutureProvider.family<bool, String>((ref, key) {
  final p = key.split('|');
  return ref.watch(transportRepositoryProvider).hasReviewed(p[0], p[1], p[2]);
});

/// 54 Rate & Review (farmer → buyer, Figma 292:774).
class RateBuyerScreen extends ConsumerStatefulWidget {
  const RateBuyerScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<RateBuyerScreen> createState() => _RateBuyerState();
}

class _RateBuyerState extends ConsumerState<RateBuyerScreen> {
  int _stars = 0;
  Set<String> _tags = {};
  final _comment = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _submit(TradeOrder o, String myUid) async {
    final l = AppLocalizations.of(context);
    if (_stars == 0) {
      KsToast.show(context, l.errPickStars);
      return;
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(transportRepositoryProvider)
          .submitReviews(
            orderId: o.id,
            fromUid: myUid,
            comment: _comment.text.trim(),
            reviews: [
              ReviewInput(
                toUid: o.buyerId,
                toRole: 'buyer',
                stars: _stars,
                tags: _tags.toList(),
              ),
            ],
          );
      ref.invalidate(reviewedProvider('${o.id}|$myUid|${o.buyerId}'));
      if (!mounted) return;
      KsToast.show(context, l.ratingThanks);
      context.pop();
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
    final o = ref.watch(orderProvider(widget.orderId)).value;
    if (o == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.rateTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final buyer = ref.watch(userByIdProvider(o.buyerId)).value;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.rateTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          _person(
            o.buyerName,
            l.orderNoLine(o.orderNo),
            buyer?.photoUrl,
            AppUi.avatarBuyer,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.howWasDeal,
            textAlign: TextAlign.center,
            style: AppTypography.bold18.normal,
          ),
          const SizedBox(height: AppSpacing.block),
          _RateBlock(
            stars: _stars,
            onStars: (v) => setState(() => _stars = v),
            tags: [
              ('on_time_pay', l.tagOnTimePay),
              ('good_behaviour', l.tagGoodBehaviour),
              ('fair_weight', l.tagFairWeight),
            ],
            selected: _tags,
            onTag: (k) => setState(() => _tags = _toggle(_tags, k)),
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.commentOptional,
            hint: l.commentHint,
            controller: _comment,
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.submit,
            loading: _busy,
            onPressed: () => _submit(o, me.uid),
          ),
        ],
      ),
    );
  }
}
