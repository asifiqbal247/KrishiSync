import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../data/listing_repository.dart';
import '../domain/listing.dart';
import 'listing_widgets.dart';

enum _Tab { ongoing, sold, draft }

/// 22 My Listings (Figma 292:519). "চলমান" = pending + active (pending shows
/// the "অনুমোদনের অপেক্ষায়" badge), "বিক্রিত" = sold, "খসড়া" = rejected by a
/// moderator (needs a new listing).
class MyListingsScreen extends ConsumerStatefulWidget {
  const MyListingsScreen({super.key});

  @override
  ConsumerState<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends ConsumerState<MyListingsScreen> {
  _Tab _tab = _Tab.ongoing;

  bool _inTab(Listing x) => switch (_tab) {
    _Tab.ongoing =>
      x.status == ListingStatus.pending || x.status == ListingStatus.active,
    _Tab.sold => x.status == ListingStatus.sold,
    _Tab.draft => x.status == ListingStatus.hidden,
  };

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(myListingsProvider);
    final tabs = [
      (_Tab.ongoing, l.tabOngoing),
      (_Tab.sold, l.tabSold),
      (_Tab.draft, l.tabDraft),
    ];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.myListingsTitle),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screen,
            AppSpacing.contentTop,
            AppSpacing.screen,
            AppSpacing.lg,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    for (final (t, label) in tabs)
                      KsPill(
                        label: label,
                        selected: _tab == t,
                        onTap: () => setState(() => _tab = t),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.block),
              Expanded(
                child: async.when(
                  loading: () => const KsSkeletonList(padded: false),
                  error: (_, _) => Center(
                    child: Text(
                      l.errorGeneric,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  data: (all) {
                    final shown = all.where(_inTab).toList();
                    if (shown.isEmpty) {
                      return Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          l.emptyFilter,
                          textAlign: TextAlign.center,
                          style: AppTypography.bodyMedium.normal.withColor(
                            AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      itemCount: shown.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (_, i) => ListingTile(
                        listing: shown[i],
                        onTap: () => context.push(
                          Routes.farmerListingDetails(shown[i].id),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.block),
              KsButton(
                label: l.addNewCrop,
                onPressed: () => context.push(Routes.farmerSell),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
