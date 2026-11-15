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
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../auth/data/user_repository.dart';
import '../../chat/presentation/chat_screens.dart';
import '../../profile/presentation/verification_screens.dart';

/// 27 Buyer Business Profile (farmer's view, Figma 292:3105). Stats a farmer
/// is allowed to see: rating, review count, verification; plus real reviews.
class BuyerProfileScreen extends ConsumerWidget {
  const BuyerProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final u = ref.watch(userByIdProvider(uid)).value;
    if (u == null) {
      return Scaffold(
          appBar: KsAppBar(title: l.buyerProfileTitle),
          body: const KsSkeletonList(rows: 3));
    }
    final reviews = ref.watch(reviewsForProvider(uid)).value;
    final rating = u.ratingCount == 0
        ? l.notAvailable
        : l.ratingShort(Fmt.number(context, u.ratingAvg, decimals: 1),
            Fmt.digits(context, '${u.ratingCount}'));

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.buyerProfileTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          KsListItem(
            thumb: KsNetImage(
                url: u.photoUrl,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: AppUi.avatarBuyer),
            title: u.business?['name'] ?? u.name,
            subtitle: u.isVerified ? l.verifiedBusiness : l.unverifiedBuyer,
            trailingText: u.ratingCount == 0
                ? null
                : Fmt.number(context, u.ratingAvg, decimals: 1),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          Row(children: [
            Expanded(child: KsStatCard(label: l.statRating, value: rating)),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: KsStatCard(
                  label: l.statVerification,
                  value: verificationText(l, u.verification)),
            ),
          ]),
          const SizedBox(height: AppSpacing.block),
          KsSectionHeader(title: l.ratingsTitle),
          if (reviews == null)
            const KsSkeletonList(rows: 2, padded: false)
          else if (reviews.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.noReviews,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final r in reviews ?? const <Review>[]) ...[
            const SizedBox(height: AppSpacing.block),
            ReviewTile(r),
          ],
          const SizedBox(
              height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
          Row(children: [
            Expanded(
                child: KsButton.outline(
                    label: l.messageShort,
                    onPressed: () => openChatWith(context, ref, uid))),
            const SizedBox(width: AppSpacing.md),
            Expanded(
                child: KsButton(
                    label: l.seeDemands,
                    onPressed: () => context.push(Routes.buyerDemands))),
          ]),
        ],
      ),
    );
  }
}
