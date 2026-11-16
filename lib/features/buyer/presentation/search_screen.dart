import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/bd_location_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_search_bar.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../farmer/data/listing_repository.dart';
import '../../farmer/domain/listing.dart';
import 'buyer_common.dart';

/// 73 Search (Figma 292:2599). Recent searches are kept on the phone;
/// popular crops and suggestions come from approved listings.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.initialQuery});

  /// Words from voice search on a home screen (V1).
  final String? initialQuery;

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  static const _recentKey = 'recent_searches';
  static const _maxRecent = 6;
  static const _speaker = 28.0;

  final _q = TextEditingController();
  List<String> _recent = const [];

  @override
  void initState() {
    super.initState();
    _recent =
        ref.read(sharedPrefsProvider).getStringList(_recentKey) ?? const [];
    final q = widget.initialQuery;
    if (q != null && q.isNotEmpty) {
      _q.text = q;
      WidgetsBinding.instance.addPostFrameCallback((_) => _remember(q));
    }
  }

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _remember(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    final list = [t, ..._recent.where((e) => e != t)].take(_maxRecent).toList();
    setState(() => _recent = list);
    await ref.read(sharedPrefsProvider).setStringList(_recentKey, list);
  }

  Future<void> _clearRecent() async {
    setState(() => _recent = const []);
    await ref.read(sharedPrefsProvider).remove(_recentKey);
  }

  void _search(String term) {
    _q.text = term;
    _q.selection = TextSelection.collapsed(offset: term.length);
    _remember(term);
    setState(() {});
  }

  bool _hit(Listing x, String q, String lang) {
    final words = q.toLowerCase().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    final hay = [
      x.cropNameBn,
      x.cropNameEn.toLowerCase(),
      x.farmerName.toLowerCase(),
      BdPlace.display(x.pickup.district, 'bn'),
      BdPlace.display(x.pickup.district, 'en').toLowerCase(),
      BdPlace.display(x.pickup.upazila, 'bn'),
      BdPlace.display(x.pickup.upazila, 'en').toLowerCase(),
    ].join(' ');
    return words.every(hay.contains);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final all = ref.watch(activeListingsProvider).value ?? const <Listing>[];
    final q = _q.text.trim();

    // Popular = crops with most approved listings.
    final byCrop = <String, List<Listing>>{};
    for (final x in all) {
      byCrop.putIfAbsent(x.cropName(lang), () => []).add(x);
    }
    final popular = byCrop.keys.toList()
      ..sort((a, b) => byCrop[b]!.length.compareTo(byCrop[a]!.length));

    // Suggestions = crop + grade groups with price range.
    final groups = <String, List<Listing>>{};
    for (final x in all) {
      groups
          .putIfAbsent(l.cropWithGrade(x.cropName(lang), x.grade), () => [])
          .add(x);
    }
    final suggestKeys = groups.keys.toList()
      ..sort((a, b) => groups[b]!.length.compareTo(groups[a]!.length));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.searchTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsSearchBar(
            hint: l.searchHint,
            controller: _q,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            onSubmitted: _remember,
          ),
          if (q.isNotEmpty) ...[
            ...() {
              final hits = all.where((x) => _hit(x, q, lang)).toList();
              if (hits.isEmpty) {
                return [
                  const SizedBox(height: AppSpacing.block),
                  Text(l.noResults,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal
                          .withColor(AppColors.textSecondary)),
                ];
              }
              return [
                for (final x in hits) ...[
                  const SizedBox(height: AppSpacing.block),
                  MarketListingTile(listing: x),
                ],
              ];
            }(),
          ] else ...[
            if (_recent.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(
                title: l.recentSearches,
                actionLabel: l.clearRecent,
                onAction: _clearRecent,
              ),
              const SizedBox(height: AppSpacing.block),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final r in _recent)
                    KsPill(label: r, selected: false, onTap: () => _search(r)),
                ],
              ),
            ],
            if (popular.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(title: l.popularNow),
              const SizedBox(height: AppSpacing.block),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final p in popular.take(6))
                    KsPill(label: p, selected: false, onTap: () => _search(p)),
                ],
              ),
            ],
            if (suggestKeys.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.block),
              KsSectionHeader(title: l.suggestions),
              for (final k in suggestKeys.take(3)) ...[
                const SizedBox(height: AppSpacing.block),
                () {
                  final g = groups[k]!;
                  final prices = g.map((x) => x.pricePerKg).toList()..sort();
                  final count = Fmt.digits(context, '${g.length}');
                  return KsListItem(
                    title: k,
                    subtitle: prices.first == prices.last
                        ? l.suggestListings(count)
                        : l.suggestListingsRange(
                            count,
                            Fmt.number(context, prices.first),
                            Fmt.number(context, prices.last)),
                    onTap: () => _search(g.first.cropName(lang)),
                  );
                }(),
              ],
            ],
            const SizedBox(height: AppSpacing.block),
            GestureDetector(
              onTap: () => KsToast.comingSoon(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.x10),
                decoration: BoxDecoration(
                  color: AppColors.bgSurface,
                  borderRadius: BorderRadius.circular(AppSpacing.x10),
                ),
                child: Row(children: [
                  Image.asset(AppUi.speaker,
                      width: _speaker, height: _speaker),
                  const SizedBox(width: AppSpacing.x10),
                  Text(l.voiceGuide,
                      style: AppTypography.bodySmallEmphasis.normal),
                ]),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
