import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../admin/data/admin_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../farmer/data/trade_doc_repository.dart';
import '../../farmer/presentation/trade_doc_screen.dart';
import '../../transport/presentation/transport_common.dart';
import 'report_screens.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

/// M6 Verification queue: users who gave an NID number, then export
/// papers waiting for a check (207).
class VerificationQueue extends ConsumerWidget {
  const VerificationQueue({super.key, this.showBack = false});
  final bool showBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(pendingVerificationProvider);
    final papers = ref.watch(pendingTradeDocsProvider).value ?? const [];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.verifyTitle, showBack: showBack),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () => ref.invalidate(pendingVerificationProvider),
        ),
        AsyncData(value: final list) => ListView(
          padding: _pad,
          children: [
            if (list.isEmpty && papers.isEmpty)
              Text(
                l.verifyEmpty,
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
                title: u.name,
                subtitle: l.nameRolePhone(roleLabel(l, u.role?.name), u.phone),
                onTap: () => context.push(Routes.moderatorVerifyUser(u.uid)),
              ),
              const SizedBox(height: AppSpacing.block),
            ],
            for (final d in papers) ...[
              KsListItem(
                thumb: KsNetImage(
                  url: d.url,
                  thumbSize: KsListItem.thumbSize.round(),
                ),
                title: ref.watch(userByIdProvider(d.uid)).value?.name ?? '',
                subtitle: tradeDocName(l, d.type),
                onTap: () => context.push(Routes.tradeDoc(d.uid, d.type.name)),
              ),
              const SizedBox(height: AppSpacing.block),
            ],
          ],
        ),
        _ => const KsSkeletonList(),
      },
    );
  }
}

/// M6 Review: identity facts + Verify / Reject.
class VerifyReviewScreen extends ConsumerStatefulWidget {
  const VerifyReviewScreen({super.key, required this.uid});
  final String uid;

  @override
  ConsumerState<VerifyReviewScreen> createState() => _VerifyReviewState();
}

class _VerifyReviewState extends ConsumerState<VerifyReviewScreen> {
  static const _docH = 180.0;
  bool _busy = false;

  Future<void> _set(AppUser u, VerificationStatus v, String modUid) async {
    final l = AppLocalizations.of(context);
    if (v == VerificationStatus.rejected) {
      final ok = await showKsConfirm(
        context,
        title: l.verifyRejectTitle,
        body: l.verifyRejectBody,
        noLabel: l.commonCancel,
        yesLabel: l.verifyRejectBtn,
      );
      if (!ok) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).setVerification(u, v, modUid);
      if (!mounted) return;
      KsToast.show(context, l.doneToast);
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
    final u = ref.watch(userByIdProvider(widget.uid)).value;
    if (u == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.verifyTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.verifyTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            thumb: KsNetImage(
              url: u.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: avatarFor(u.role?.name),
            ),
            title: u.name,
            subtitle: roleLabel(l, u.role?.name),
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(
            children: [
              KsInfoRow(l.profilePhone, u.phone),
              if (u.business != null) ...[
                KsInfoRow(l.rowBizName, u.business!['name'] ?? ''),
                KsInfoRow(l.tradeLicense, u.business!['licenseNo'] ?? ''),
                if ((u.business!['tin'] ?? '').isNotEmpty)
                  KsInfoRow(l.tinLabel, u.business!['tin']!),
              ] else
                KsInfoRow(l.rowNid, u.nidNumber ?? l.notAvailable),
              KsInfoRow(l.fieldLocation, placeFull(context, u.location)),
              if (u.createdAt != null)
                KsInfoRow(l.rowJoined, Fmt.date(context, u.createdAt!)),
            ],
          ),
          // Uploaded documents (69 / 139).
          for (final url in u.verificationDocs.values) ...[
            const SizedBox(height: AppSpacing.block),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: SizedBox(
                height: _docH,
                child: KsNetImage(url: url),
              ),
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          if (u.verification == VerificationStatus.pending)
            Row(
              children: [
                Expanded(
                  child: KsButton.destructive(
                    label: l.verifyRejectBtn,
                    onPressed: _busy
                        ? null
                        : () => _set(u, VerificationStatus.rejected, me.uid),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: KsButton(
                    label: l.verifyApprove,
                    loading: _busy,
                    onPressed: () =>
                        _set(u, VerificationStatus.verified, me.uid),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
