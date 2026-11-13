import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/domain/crop_catalog.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../domain/listing.dart';

/// Label + colours for the HF/List Item / Status badge per listing status.
(String, Color, Color) listingBadge(AppLocalizations l, ListingStatus s) =>
    switch (s) {
      ListingStatus.pending => (
          l.statusPending,
          AppColors.bgWarningSubtle,
          AppColors.textWarning
        ),
      ListingStatus.active => (
          l.statusActive,
          AppColors.bgSuccessSubtle,
          AppColors.textSuccess
        ),
      ListingStatus.sold => (
          l.statusSold,
          AppColors.bgMuted,
          AppColors.textSecondary
        ),
      ListingStatus.hidden => (
          l.statusHidden,
          AppColors.bgErrorSubtle,
          AppColors.textError
        ),
    };

/// One listing row (HF/List Item / Status): photo, "Crop (Grade X)",
/// "qty kg · ৳ price/kg", status badge.
class ListingTile extends StatelessWidget {
  const ListingTile({
    super.key,
    required this.listing,
    required this.onTap,
    this.subtitle,
  });

  final Listing listing;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final (badge, bg, fg) = listingBadge(l, listing.status);
    return KsListItem(
      thumb: KsNetImage(
        url: listing.photo,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: CropCatalog.imageFor(listing.cropKey),
      ),
      title: l.cropWithGrade(listing.cropName(lang), listing.grade),
      subtitle: subtitle ??
          l.listingSubtitle(Fmt.number(context, listing.availableKg),
              Fmt.number(context, listing.pricePerKg)),
      badge: badge,
      badgeColor: bg,
      badgeTextColor: fg,
      onTap: onTap,
    );
  }
}
