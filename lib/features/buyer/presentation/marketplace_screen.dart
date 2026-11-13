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
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_cards.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../farmer/data/listing_repository.dart';
import '../../farmer/domain/listing.dart';
import 'buyer_common.dart';

/// 74 Marketplace (Figma 292:1006): approved listings with category,
/// search and filter (area, quantity, price).
class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  static const _catRowH = 90.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final filter = ref.watch(marketFilterProvider);
    final async = ref.watch(activeListingsProvider);
    final cats = marketCategories(l, withAll: true);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.marketTitle,
        onBack: () => ref.read(buyerTabProvider.notifier).go(0),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsSearchBar(
            hint: l.marketSearchHint,
            readOnly: true,
            onTap: () => context.push(Routes.buyerSearch),
          ),
          const SizedBox(height: AppSpacing.block),
          SizedBox(
            height: _catRowH,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(width: AppSpacing.md),
              itemBuilder: (_, i) {
                final (cat, img, label) = cats[i];
                return KsCategoryItem(
                  image: img,
                  label: label,
                  selected: filter.category == cat,
                  onTap: () => ref.read(marketFilterProvider.notifier).set(
                      filter.copyWith(
                          category: cat, clearCategory: cat == null)),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          ...async.when(
            loading: () => [const Center(child: CircularProgressIndicator())],
            error: (_, _) => [Text(l.errorGeneric)],
            data: (all) {
              final shown = all.where(filter.matches).toList();
              return [
                InkWell(
                  onTap: () => _openFilter(context, ref, all),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        minHeight: AppSizes.chipMinHeight),
                    child: Row(
                      children: [
                        Text(
                            l.resultsCount(
                                Fmt.digits(context, '${shown.length}')),
                            style: AppTypography.bodySmallStrong.normal),
                        const Spacer(),
                        Text(l.filterLabel,
                            style: AppTypography.bodySmallEmphasis.normal
                                .withColor(AppColors.textBrand)),
                        const SizedBox(width: AppSpacing.xs),
                        const AppIcon(AppIcons.chevronRight,
                            size: AppSizes.iconXs,
                            color: AppColors.iconBrand),
                      ],
                    ),
                  ),
                ),
                if (shown.isEmpty) ...[
                  const SizedBox(height: AppSpacing.block),
                  Text(l.noResults,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ],
                for (final x in shown) ...[
                  const SizedBox(height: AppSpacing.block),
                  MarketListingTile(listing: x),
                ],
              ];
            },
          ),
        ],
      ),
    );
  }

  Future<void> _openFilter(
      BuildContext context, WidgetRef ref, List<Listing> all) async {
    final result = await showModalBottomSheet<MarketFilter>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _FilterSheet(current: ref.read(marketFilterProvider), all: all),
    );
    if (result != null) ref.read(marketFilterProvider.notifier).set(result);
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.current, required this.all});
  final MarketFilter current;
  final List<Listing> all;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late String? _district = widget.current.districtId;
  late final _minQty = TextEditingController(
      text: widget.current.minQty?.toString() ?? '');
  late final _maxPrice = TextEditingController(
      text: widget.current.maxPrice?.toString() ?? '');

  @override
  void dispose() {
    _minQty.dispose();
    _maxPrice.dispose();
    super.dispose();
  }

  num? _n(TextEditingController c) =>
      num.tryParse(Fmt.latinDigits(c.text.trim()));

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    // Districts that actually have listings.
    final districts = <String, String>{};
    for (final x in widget.all) {
      final id = x.pickup.districtId;
      if (id != null) districts[id] = BdPlace.display(x.pickup.district, lang);
    }
    final numFmt = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))];

    return Padding(
      padding: EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.s2xl,
          AppSpacing.screen,
          AppSpacing.screen + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.filterTitle, style: AppTypography.h3.normal),
            const SizedBox(height: AppSpacing.block),
            Text(l.filterDistrict,
                style: AppTypography.bodyMediumEmphasis.normal),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                KsPill(
                    label: l.filterAnyDistrict,
                    selected: _district == null,
                    onTap: () => setState(() => _district = null)),
                for (final e in districts.entries)
                  KsPill(
                      label: e.value,
                      selected: _district == e.key,
                      onTap: () => setState(() => _district = e.key)),
              ],
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.filterMinQty,
              controller: _minQty,
              suffixText: l.unitKg,
              keyboardType: TextInputType.number,
              inputFormatters: numFmt,
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.filterMaxPrice,
              controller: _maxPrice,
              suffixText: l.sellPriceUnit,
              keyboardType: TextInputType.number,
              inputFormatters: numFmt,
            ),
            const SizedBox(height: AppSpacing.s2xl),
            Row(children: [
              Expanded(
                child: KsButton.outline(
                  label: l.filterClear,
                  onPressed: () => Navigator.pop(context,
                      MarketFilter(category: widget.current.category)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: KsButton(
                  label: l.filterApply,
                  onPressed: () => Navigator.pop(
                    context,
                    MarketFilter(
                      category: widget.current.category,
                      districtId: _district,
                      minQty: _n(_minQty),
                      maxPrice: _n(_maxPrice),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
