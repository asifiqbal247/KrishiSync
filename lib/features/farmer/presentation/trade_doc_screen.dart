import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/services/pdf_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_states.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../chat/presentation/chat_screens.dart';
import '../data/trade_doc_repository.dart';

/// Paper name as on 37 (export) and the driver's verification list.
String tradeDocName(AppLocalizations l, TradeDocType t) => switch (t) {
  TradeDocType.phyto => l.exDoc1,
  TradeDocType.license => l.exDoc2,
  TradeDocType.driving => l.drivingLicense,
  TradeDocType.vehicle => l.vehiclePapers,
};

/// Status line for a paper row (not uploaded / waiting / verified / …).
String tradeDocStatusText(AppLocalizations l, TradeDoc? d) => switch (d) {
  null => l.docNoneTitle,
  TradeDoc(expired: true) => l.docExpired,
  TradeDoc(status: TradeDocStatus.verified) => l.docVerified,
  TradeDoc(status: TradeDocStatus.pending) => l.docPending,
  TradeDoc(status: TradeDocStatus.rejected) => l.docRejected,
};

/// 207 Document Viewer (Figma 292:3662). The owner sees PDF download and
/// re-upload; a moderator checking a waiting paper sees reject / verify.
class TradeDocScreen extends ConsumerStatefulWidget {
  const TradeDocScreen({super.key, required this.uid, required this.type});
  final String uid;
  final TradeDocType type;

  @override
  ConsumerState<TradeDocScreen> createState() => _TradeDocState();
}

class _TradeDocState extends ConsumerState<TradeDocScreen> {
  static const _imageH = 300.0;
  static const _rowMinH = 36.0;
  bool _busy = false;

  /// Photo of the paper → expiry date → upload → back to 'pending'.
  Future<void> _upload() async {
    final l = AppLocalizations.of(context);
    final file = await pickPhoto(context);
    if (file == null || !mounted) return;
    final now = DateTime.now();
    final exp = await showDatePicker(
      context: context,
      helpText: l.docExpiryPick,
      initialDate: DateTime(now.year + 1, now.month, now.day),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );
    if (exp == null || !mounted) return;
    setState(() => _busy = true);
    try {
      final img = await ref
          .read(imageStorageProvider)
          .upload(file, kind: ImageKind.tradeDoc, ownerUid: widget.uid);
      await ref
          .read(tradeDocRepositoryProvider)
          .save(
            uid: widget.uid,
            type: widget.type,
            url: img.url,
            expiresAt: exp,
          );
      if (mounted) KsToast.show(context, l.docSent);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _review(TradeDoc d, bool ok, String modUid) async {
    final l = AppLocalizations.of(context);
    if (!ok) {
      final sure = await showKsConfirm(
        context,
        title: l.verifyRejectTitle,
        body: l.verifyRejectBody,
        noLabel: l.commonCancel,
        yesLabel: l.verifyRejectBtn,
      );
      if (!sure || !mounted) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(tradeDocRepositoryProvider).review(d, ok, modUid);
      if (mounted) KsToast.show(context, l.doneToast);
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// PDF of the paper: name, photo and the three facts.
  Future<void> _pdf(TradeDoc d, List<(String, String)> rows) async {
    final l = AppLocalizations.of(context);
    final photo = CachedNetworkImageProvider(d.url);
    setState(() => _busy = true);
    try {
      // Load first, so the off-screen page has the picture ready.
      await precacheImage(photo, context);
      if (!mounted) return;
      final name = tradeDocName(l, d.type);
      await PdfService.share(
        context,
        title: name,
        fileName: 'golaghor-${d.type.name}',
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image(image: photo, fit: BoxFit.contain),
          ),
          const SizedBox(height: AppSpacing.block),
          _info(rows),
        ],
      );
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// Figma "Info": 1px border, radius 12, px 16 py 8, rows ≥36 high,
  /// Regular 14 secondary label, SemiBold 14 value.
  Widget _info(List<(String, String)> rows) => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.lg,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      border: Border.all(color: AppColors.borderDefault),
    ),
    child: Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.s2xs),
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _rowMinH),
            child: Row(
              children: [
                Text(
                  rows[i].$1,
                  style: AppTypography.bodyMedium.normal.withColor(
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: AppTypography.bodyMediumStrong.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    final async = ref.watch(tradeDocProvider((widget.uid, widget.type)));
    final mine = me?.uid == widget.uid;
    final isMod = me?.role == UserRole.moderator || me?.role == UserRole.admin;
    final name = tradeDocName(l, widget.type);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.attachDoc),
      body: switch (async) {
        AsyncError(:final error) => KsErrorState.from(
          error,
          onRetry: () =>
              ref.invalidate(tradeDocProvider((widget.uid, widget.type))),
        ),
        AsyncData(value: null) => KsEmptyState(
          title: l.docNoneTitle,
          body: mine ? l.docNoneBody : name,
          ctaLabel: mine ? l.docUpload : null,
          onCta: _busy ? null : _upload,
        ),
        AsyncData(value: final TradeDoc d) => () {
          final status = d.expired
              ? l.docExpired
              : switch (d.status) {
                  TradeDocStatus.verified => l.docVerified,
                  TradeDocStatus.pending => l.docPending,
                  TradeDocStatus.rejected => l.docRejected,
                };
          final rows = [
            (l.rowStatus, status),
            if (d.uploadedAt != null)
              (l.rowUploaded, Fmt.dateFull(context, d.uploadedAt!)),
            if (d.expiresAt != null)
              (l.rowExpiry, Fmt.dateFull(context, d.expiresAt!)),
          ];
          final reviewing =
              !mine && isMod && d.status == TradeDocStatus.pending;
          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.contentTop,
              AppSpacing.screen,
              AppSpacing.lg,
            ),
            children: [
              Text(name, style: AppTypography.headingBold20.normal),
              const SizedBox(height: AppSpacing.block),
              GestureDetector(
                onTap: () => showPhoto(context, d.url),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  child: SizedBox(
                    height: _imageH,
                    child: KsNetImage(url: d.url),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.block),
              _info(rows),
              // Figma: 14 gap + 4px spacer + 14 gap before the buttons.
              const SizedBox(
                height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
              ),
              Row(
                children: [
                  Expanded(
                    child: reviewing
                        ? KsButton.destructive(
                            label: l.verifyRejectBtn,
                            onPressed: _busy || me == null
                                ? null
                                : () => _review(d, false, me.uid),
                          )
                        : KsButton.outline(
                            label: l.docPdf,
                            onPressed: _busy ? null : () => _pdf(d, rows),
                          ),
                  ),
                  if (mine || reviewing) ...[
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: reviewing
                          ? KsButton(
                              label: l.verifyApprove,
                              loading: _busy,
                              onPressed: me == null
                                  ? null
                                  : () => _review(d, true, me.uid),
                            )
                          : KsButton(
                              label: l.docReupload,
                              loading: _busy,
                              onPressed: _upload,
                            ),
                    ),
                  ],
                ],
              ),
            ],
          );
        }(),
        _ => const KsSkeletonList(rows: 3),
      },
    );
  }
}
