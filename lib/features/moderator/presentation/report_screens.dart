import 'dart:io';

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
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../trade/data/trade_repository.dart';
import '../data/report_repository.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

String reasonLabel(AppLocalizations l, String key) => switch (key) {
  'driver_behavior' => l.reason_driver_behavior,
  'late_delivery' => l.reason_late_delivery,
  'app_problem' => l.reason_app_problem,
  _ => l.reason_other,
};

String roleLabel(AppLocalizations l, String? role) => switch (role) {
  'farmer' => l.roleFarmer,
  'buyer' => l.rowBuyer,
  'transporter' => l.roleTransporter,
  'moderator' => l.roleModerator,
  'admin' => l.roleAdmin,
  _ => l.noRoleYet,
};

/// Default avatar picture for a role (when the user has no photo).
String avatarFor(String? role) => switch (role) {
  'buyer' => AppUi.avatarBuyer,
  'transporter' => AppUi.avatarDriver,
  _ => AppUi.avatarFarmer,
};

/// 203 Report Issue (about an order) / 204 (general), Figma 292:4077 /
/// 371:6017. Goes to the moderator queue (M4).
class ReportIssueScreen extends ConsumerStatefulWidget {
  const ReportIssueScreen({super.key, this.orderId});
  final String? orderId;

  @override
  ConsumerState<ReportIssueScreen> createState() => _ReportIssueState();
}

class _ReportIssueState extends ConsumerState<ReportIssueScreen> {
  String? _reason;
  File? _photo;
  final _details = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _details.dispose();
    super.dispose();
  }

  Future<void> _submit(AppUser me) async {
    final l = AppLocalizations.of(context);
    if (_reason == null) {
      KsToast.show(context, l.errPickReason);
      return;
    }
    setState(() => _busy = true);
    try {
      String? url;
      if (_photo != null) {
        url =
            (await ref
                    .read(imageStorageProvider)
                    .upload(_photo!, kind: ImageKind.report, ownerUid: me.uid))
                .url;
      }
      final order = widget.orderId == null
          ? null
          : ref.read(orderProvider(widget.orderId!)).value;
      await ref
          .read(reportRepositoryProvider)
          .create(
            me: me,
            order: order,
            reason: _reason!,
            details: _details.text.trim(),
            photoUrl: url,
          );
      if (!mounted) return;
      KsToast.show(context, l.reportSent);
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
    final lang = Localizations.localeOf(context).languageCode;
    final me = ref.watch(currentUserProvider).value;
    final o = widget.orderId == null
        ? null
        : ref.watch(orderProvider(widget.orderId!)).value;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.reportTitle),
      body: ListView(
        padding: _pad,
        children: [
          if (o != null)
            KsListItem(
              thumb: KsNetImage(
                url: o.photo,
                thumbSize: KsListItem.thumbSize.round(),
                fallbackAsset: CropCatalog.imageFor(o.cropKey),
              ),
              title: l.cropQtyTitle(
                o.cropName(lang),
                qtyText(context, o.quantityKg),
              ),
              subtitle: o.orderNo,
              showChevron: false,
            )
          else
            KsListItem(
              thumb: Container(
                color: AppColors.bgSubtle,
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Image.asset(AppUi.tipClipboard),
              ),
              title: l.reportGeneralTitle,
              subtitle: l.reportGeneralSub,
              showChevron: false,
            ),
          const SizedBox(height: AppSpacing.block),
          Text(l.reportWhat, style: AppTypography.bodyMediumEmphasis.normal),
          const SizedBox(height: AppSpacing.block),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final r in ReportReasons.all)
                KsPill(
                  label: reasonLabel(l, r),
                  selected: _reason == r,
                  onTap: () => setState(() => _reason = r),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.block),
          KsUploadBox(
            label: l.reportPhoto,
            file: _photo,
            height: _photo == null
                ? KsUploadBox.defaultHeight
                : KsUploadBox.previewHeight,
            onTap: () async {
              final f = await pickPhoto(context);
              if (f != null) setState(() => _photo = f);
            },
          ),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.reportDetails,
            hint: l.reportDetailsHint,
            controller: _details,
          ),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.reportNote,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.reportSubmit,
            loading: _busy,
            onPressed: me == null ? null : () => _submit(me),
          ),
        ],
      ),
    );
  }
}

/// M4 Reports Queue (Moderator, same theme). [showBack] when opened by the
/// Admin from Moderation.
class ReportsQueue extends ConsumerStatefulWidget {
  const ReportsQueue({super.key, this.showBack = false});
  final bool showBack;

  @override
  ConsumerState<ReportsQueue> createState() => _ReportsQueueState();
}

class _ReportsQueueState extends ConsumerState<ReportsQueue> {
  ReportStatus _f = ReportStatus.open;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final async = ref.watch(reportsByStatusProvider(_f));
    final pills = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final (s, label) in [
          (ReportStatus.open, l.rs_open),
          (ReportStatus.inReview, l.rs_inReview),
          (ReportStatus.resolved, l.rs_resolved),
          (ReportStatus.dismissed, l.rs_dismissed),
        ])
          KsPill(
            label: label,
            selected: _f == s,
            onTap: () => setState(() => _f = s),
          ),
      ],
    );
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.modReportsTitle, showBack: widget.showBack),
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
            child: pills,
          ),
          Expanded(
            child: switch (async) {
              AsyncError(:final error) => KsErrorState.from(
                error,
                onRetry: () => ref.invalidate(reportsByStatusProvider(_f)),
              ),
              AsyncData(value: final list) => ListView(
                padding: _pad,
                children: [
                  if (list.isEmpty)
                    Text(
                      l.noReports,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium.normal.withColor(
                        AppColors.textSecondary,
                      ),
                    ),
                  for (final r in list) ...[
                    KsListItem(
                      title: r.orderNo == null
                          ? reasonLabel(l, r.reason)
                          : l.orderLine(r.orderNo!, reasonLabel(l, r.reason)),
                      subtitle: l.placeDate(
                        l.nameRole(
                          r.reporterName,
                          roleLabel(l, r.reporterRole),
                        ),
                        r.createdAt == null
                            ? ''
                            : Fmt.date(context, r.createdAt!),
                      ),
                      badge: r.escalated ? l.escalatedBadge : null,
                      badgeColor: AppColors.bgWarningSubtle,
                      badgeTextColor: AppColors.textWarning,
                      onTap: () => context.push(Routes.moderatorReport(r.id)),
                    ),
                    const SizedBox(height: AppSpacing.block),
                  ],
                ],
              ),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

/// M5 Report Detail: facts + Start review / Resolve / Dismiss / Escalate.
class ReportDetailScreen extends ConsumerStatefulWidget {
  const ReportDetailScreen({super.key, required this.reportId});
  final String reportId;

  @override
  ConsumerState<ReportDetailScreen> createState() => _ReportDetailState();
}

class _ReportDetailState extends ConsumerState<ReportDetailScreen> {
  bool _busy = false;

  Future<String?> _askNote() async {
    final l = AppLocalizations.of(context);
    final c = TextEditingController();
    final r = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
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
            Text(l.noteSheetTitle, style: AppTypography.h3.normal),
            const SizedBox(height: AppSpacing.md),
            KsTextField(label: '', hint: l.noteHint, controller: c),
            const SizedBox(height: AppSpacing.block),
            KsButton(
              label: l.sendBtn,
              onPressed: () => Navigator.pop(ctx, c.text.trim()),
            ),
          ],
        ),
      ),
    );
    c.dispose();
    return r;
  }

  Future<void> _set(
    Report r,
    ReportStatus s,
    String uid, {
    bool withNote = false,
    bool? escalate,
  }) async {
    final l = AppLocalizations.of(context);
    String? note;
    if (withNote) {
      note = await _askNote();
      if (note == null) return; // sheet dismissed
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(reportRepositoryProvider)
          .setStatus(r, s, modUid: uid, note: note, escalate: escalate);
      if (mounted) KsToast.show(context, l.doneToast);
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
    final r = ref.watch(reportProvider(widget.reportId)).value;
    if (r == null || me == null) {
      return Scaffold(
        appBar: KsAppBar(title: l.reportDetailTitle),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final lang = Localizations.localeOf(context).languageCode;
    final closed =
        r.status == ReportStatus.resolved || r.status == ReportStatus.dismissed;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.reportDetailTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsInfoBox(
            children: [
              KsInfoRow(l.rowReason, reasonLabel(l, r.reason)),
              KsInfoRow(
                l.rowReporter,
                l.nameRole(r.reporterName, roleLabel(l, r.reporterRole)),
              ),
              if (r.createdAt != null)
                KsInfoRow(l.rowDate, Fmt.date(context, r.createdAt!)),
              KsInfoRow(l.rowOfferStatus, switch (r.status) {
                ReportStatus.open => l.rs_open,
                ReportStatus.inReview => l.rs_inReview,
                ReportStatus.resolved => l.rs_resolved,
                ReportStatus.dismissed => l.rs_dismissed,
              }),
              if (r.orderId != null)
                KsLinkRow(
                  label: l.rowOrder,
                  value: l.orderLine(r.orderNo ?? '', r.cropName(lang) ?? ''),
                  onTap: () => context.push(Routes.order(r.orderId!)),
                ),
            ],
          ),
          if (r.escalated) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(title: l.escalatedBadge, warning: true),
          ],
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            title: l.rowDetails,
            body: r.details.isEmpty ? l.notAvailable : r.details,
          ),
          if ((r.modNote ?? '').isNotEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(title: l.rowModNote, body: r.modNote),
          ],
          if (r.photoUrl != null) ...[
            const SizedBox(height: AppSpacing.block),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: SizedBox(
                height: KsUploadBox.previewHeight * 1.5,
                child: KsNetImage(url: r.photoUrl),
              ),
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          if (!closed) ...[
            if (r.status == ReportStatus.open) ...[
              KsButton.secondary(
                label: l.startReview,
                onPressed: _busy
                    ? null
                    : () => _set(r, ReportStatus.inReview, me.uid),
              ),
              const SizedBox(height: AppSpacing.block),
            ],
            KsButton(
              label: l.resolveReport,
              loading: _busy,
              onPressed: () =>
                  _set(r, ReportStatus.resolved, me.uid, withNote: true),
            ),
            const SizedBox(height: AppSpacing.block),
            Row(
              children: [
                Expanded(
                  child: KsButton.destructive(
                    label: l.dismissReport,
                    onPressed: _busy
                        ? null
                        : () async {
                            final ok = await showKsConfirm(
                              context,
                              title: l.dismissReport,
                              body: l.reportNote,
                              noLabel: l.commonCancel,
                              yesLabel: l.dismissReport,
                            );
                            if (ok) {
                              await _set(
                                r,
                                ReportStatus.dismissed,
                                me.uid,
                                withNote: true,
                              );
                            }
                          },
                  ),
                ),
                if (!r.escalated && me.role == UserRole.moderator) ...[
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: KsButton.outline(
                      label: l.escalateReport,
                      onPressed: _busy
                          ? null
                          : () => _set(
                              r,
                              ReportStatus.inReview,
                              me.uid,
                              escalate: true,
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
