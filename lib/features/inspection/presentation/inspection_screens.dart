import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/utils/sheet_utils.dart';
import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/services/pdf_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_net_image.dart';
import '../../../shared/widgets/ks_pill.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/presentation/phone_auth_controller.dart';
import '../../buyer/presentation/buyer_common.dart';
import '../../trade/data/trade_repository.dart';
import '../../trade/domain/trade_models.dart';
import '../../trade/presentation/trace_screen.dart';
import '../../transport/presentation/transport_common.dart';
import '../../demand/presentation/quality_standard_screen.dart';
import '../data/inspection_repository.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);
const _gapBeforeCta = AppSpacing.block + AppSpacing.xs + AppSpacing.block;
const _heroH = 96.0;
const _maxPhotos = 3;

Widget _loading(String title) => Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: title),
      body: const KsSkeletonList(),
    );

/// Five checklist lines (Figma 89). Allowed damage depends on the grade.
/// 89 checklist = the crop's grade standard (97), one line per item.
List<String> checklistLabels(
        BuildContext context, String cropKey, String grade) =>
    [
      for (final (k, v) in qualityStandardRows(context, cropKey, grade))
        AppLocalizations.of(context).stdCheckLine(k, v),
    ];

String decisionLabel(AppLocalizations l, InspectionDecision d) => switch (d) {
      InspectionDecision.approve => l.decApprove,
      InspectionDecision.partial => l.decPartial,
      InspectionDecision.cancel => l.decCancel,
    };

String reasonLabel(AppLocalizations l, RejectReason r) => switch (r) {
      RejectReason.small => l.reasonSmall,
      RejectReason.damaged => l.reasonDamaged,
      RejectReason.lowGrade => l.reasonLowGrade,
    };

// ───────────────────────── Buyer: assign ─────────────────────────

/// Buyer names the inspector (name + phone). The inspector logs in to the
/// app with that number; the buyer can also send the invite as a message.
Future<void> showAssignInspectorSheet(
    BuildContext context, WidgetRef ref, TradeOrder o, Inspection? current) async {
  final l = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final name = TextEditingController(text: current?.inspectorName ?? '');
  final phone = TextEditingController(
      text: current == null ? '' : current.inspectorPhone.replaceFirst('+88', ''));
  String? nameErr;
  String? phoneErr;
  var busy = false;
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => Padding(
        padding: EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.xl,
            AppSpacing.screen, AppSpacing.s2xl + MediaQuery.of(ctx).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.assignInspTitle, style: AppTypography.headingBold20.normal),
            const SizedBox(height: AppSpacing.sm),
            Text(l.assignInspBody,
                style: AppTypography.bodySmall.normal
                    .withColor(AppColors.textSecondary)),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.fieldInspName,
              controller: name,
              errorText: nameErr,
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.fieldInspPhone,
              hint: l.loginPhoneHint,
              controller: phone,
              keyboardType: TextInputType.phone,
              prefixText: '+880',
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]')),
                LengthLimitingTextInputFormatter(11),
              ],
              errorText: phoneErr,
            ),
            const SizedBox(height: AppSpacing.block),
            KsButton(
              label: l.sendInvite,
              loading: busy,
              onPressed: () async {
                final local = BdPhone.normalizeLocal(Fmt.latinDigits(phone.text));
                final me = ref.read(currentUserProvider).value;
                setS(() {
                  nameErr = name.text.trim().isEmpty ? l.errNameRequired : null;
                  phoneErr = local == null
                      ? l.loginInvalidPhone
                      : (me != null && BdPhone.toE164(local) == me.phone)
                          ? l.errInspNotSelf
                          : null;
                });
                if (nameErr != null || phoneErr != null) return;
                setS(() => busy = true);
                try {
                  await ref.read(inspectionRepositoryProvider).invite(o,
                      name: name.text.trim(), phoneE164: BdPhone.toE164(local!));
                  if (ctx.mounted) Navigator.pop(ctx);
                  // Let the buyer send the invite by SMS / WhatsApp.
                  await SharePlus.instance.share(ShareParams(
                      text: l.inspInviteText(name.text.trim(), o.orderNo,
                          o.cropName(lang),
                          BdPhone.pretty(local))));
                } catch (_) {
                  setS(() => busy = false);
                  if (context.mounted) KsToast.show(context, l.errorGeneric);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
  disposeAfterSheet([name, phone]);
}

// ───────────────────────── Inspector ─────────────────────────

/// 88 Inspector – Assigned Pickups (Figma 292:3428).
class InspectorHomeScreen extends ConsumerWidget {
  const InspectorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final async = ref.watch(myInvitesProvider);
    final me = ref.watch(currentUserProvider).value;
    final list = async.value ?? const <Inspection>[];
    if (async.isLoading && list.isEmpty) return _loading(l.inspHomeTitle);
    final open = list.where((i) => !i.done).toList();
    final head = open.isNotEmpty ? open.first : (list.isEmpty ? null : list.first);
    final headOrder = head == null ? null : ref.watch(orderProvider(head.orderId)).value;
    final driver = headOrder?.transporterId == null
        ? null
        : ref.watch(userByIdProvider(headOrder!.transporterId!)).value;

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: l.inspHomeTitle,
        showBack: me?.hasRole ?? false,
        // Opened from the profile: back; after a fresh start: role home.
        onBack: () => context.canPop()
            ? context.pop()
            : context.go(me?.role == null
                ? Routes.inspector
                : Routes.homeFor(me!.role!)),
      ),
      body: ListView(
        padding: _pad,
        children: [
          if (head != null) ...[
            KsNoteBox(
              warning: true,
              title: l.inspInvitedBy(head.buyerName),
              body: headOrder == null
                  ? head.orderNo
                  : l.inspOrderLine(head.orderNo, head.cropName(lang),
                      qtyText(context, headOrder.quantityKg),
                      headOrder.pickupDate == null
                          ? ''
                          : Fmt.date(context, headOrder.pickupDate!)),
            ),
            if (headOrder?.transporterName != null) ...[
              const SizedBox(height: AppSpacing.block),
              KsNoteBox(
                title: l.inspTruckBooked(headOrder!.transporterName!),
                body: l.inspTruckBookedBody(placeFull(context, headOrder.pickup)),
              ),
            ],
          ],
          const SizedBox(height: AppSpacing.block),
          Text(l.inspPickups(Fmt.digits(context, '${list.length}')),
              style: AppTypography.bodyMediumStrong.normal),
          if (list.isEmpty) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.inspNone,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal
                    .withColor(AppColors.textSecondary)),
          ],
          for (final (i, x) in list.indexed) ...[
            const SizedBox(height: AppSpacing.block),
            _PickupRow(index: i, x: x, highlighted: x == head && !x.done),
          ],
          if (headOrder != null) ...[
            const SizedBox(height: AppSpacing.block),
            Text(l.inspChalan, style: AppTypography.bodyMediumStrong.normal),
            const SizedBox(height: AppSpacing.block),
            KsInfoBox(children: [
              KsInfoRow(l.inspGrade, l.inspGradeValue(headOrder.grade)),
              KsInfoRow(l.inspTruck, headOrder.transporterName ?? l.stepWaiting),
            ]),
            const SizedBox(height: AppSpacing.block),
            Row(children: [
              Expanded(
                child: KsButton.outline(
                  label: l.callDriver,
                  compact: true,
                  onPressed: driver?.phone == null
                      ? null
                      : () => launchUrl(Uri(scheme: 'tel', path: driver!.phone)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: KsButton.outline(
                  label: l.seeRouteMap,
                  compact: true,
                  onPressed: headOrder.pickup.geo == null
                      ? null
                      : () => launchUrl(
                          Uri.parse('https://www.google.com/maps/dir/?api=1'
                              '&destination=${headOrder.pickup.geo!.latitude},'
                              '${headOrder.pickup.geo!.longitude}'),
                          mode: LaunchMode.externalApplication),
                ),
              ),
            ]),
          ],
          if (!(me?.hasRole ?? true)) ...[
            const SizedBox(height: _gapBeforeCta),
            KsButton.text(
              label: l.logout,
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickupRow extends ConsumerWidget {
  const _PickupRow({required this.index, required this.x, required this.highlighted});
  final int index;
  final Inspection x;
  final bool highlighted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final o = ref.watch(orderProvider(x.orderId)).value;
    final farmer = ref.watch(userByIdProvider(x.farmerId)).value;
    final closed = o != null &&
        (o.status == OrderStatus.cancelled ||
            o.timeline.containsKey('pickedUp'));
    final (badge, bg, fg) = x.done
        ? (decisionLabel(l, x.decision ?? InspectionDecision.approve),
            AppColors.bgMuted, AppColors.textSecondary)
        : closed
            ? (l.inspClosed, AppColors.bgMuted, AppColors.textSecondary)
            : (l.inspStart, AppColors.bgSuccessSubtle, AppColors.textSuccess);
    return KsListItem(
      highlighted: highlighted,
      thumb: KsNetImage(
        url: farmer?.photoUrl,
        thumbSize: KsListItem.thumbSize.round(),
        fallbackAsset: AppUi.avatarFarmer,
      ),
      title: l.numberedName(Fmt.digits(context, '${index + 1}'), x.farmerName),
      subtitle: o == null
          ? x.orderNo
          : [
              placeFull(context, o.pickup),
              qtyText(context, o.quantityKg),
              if (o.pickupDate != null) Fmt.date(context, o.pickupDate!),
            ].join(' · '),
      badge: badge,
      badgeColor: bg,
      badgeTextColor: fg,
      onTap: () => context.push(x.done || closed
          ? Routes.inspSent(x.orderId)
          : Routes.inspCheck(x.orderId)),
    );
  }
}

enum _Mode { check, partial, cancel }

/// 89 Quality Check (292:3449) → 90 Partial Load (292:3910) / 91 Cancel Load
/// (292:3933). One screen in three steps; back returns to the checklist.
class QualityCheckScreen extends ConsumerStatefulWidget {
  const QualityCheckScreen({super.key, required this.orderId});
  final String orderId;

  @override
  ConsumerState<QualityCheckScreen> createState() => _QualityState();
}

class _QualityState extends ConsumerState<QualityCheckScreen> {
  _Mode _mode = _Mode.check;
  InspectionDecision _decision = InspectionDecision.approve;
  final List<bool?> _checks = List.filled(InspectionRepository.checklistSize, true);
  final _kg = TextEditingController();
  final _accept = TextEditingController();
  RejectReason _reason = RejectReason.small;
  final List<File> _photos = [];
  final List<File> _rejectPhotos = [];
  bool _filled = false;
  bool _busy = false;
  String? _err;

  @override
  void dispose() {
    _kg.dispose();
    _accept.dispose();
    super.dispose();
  }

  num get _weighed => num.tryParse(Fmt.latinDigits(_kg.text.trim())) ?? 0;
  num get _acceptKg => num.tryParse(Fmt.latinDigits(_accept.text.trim())) ?? 0;

  Future<void> _submit(TradeOrder o) async {
    final l = AppLocalizations.of(context);
    final me = ref.read(currentUserProvider).value;
    if (me == null) return;
    final shots = _mode == _Mode.partial ? _rejectPhotos : _photos;
    setState(() {
      _err = _weighed <= 0
          ? l.errQtyInvalid
          : (_mode == _Mode.partial && (_acceptKg <= 0 || _acceptKg >= _weighed))
              ? l.errAcceptKg(qtyText(context, _weighed))
              : shots.isEmpty
                  ? l.errInspPhoto
                  : null;
    });
    if (_err != null) return;
    if (_mode == _Mode.cancel) {
      final ok = await showKsConfirm(context,
          title: l.cancelLoadQ,
          body: l.cancelLoadBody,
          noLabel: l.noGoBack,
          yesLabel: l.yesCancelIt);
      if (!ok) return;
    }
    setState(() => _busy = true);
    try {
      final urls = <String>[];
      for (final f in [..._photos, if (_mode == _Mode.partial) ..._rejectPhotos]) {
        urls.add((await ref.read(imageStorageProvider).upload(f,
                kind: ImageKind.delivery, ownerUid: me.uid))
            .url);
      }
      await ref.read(inspectionRepositoryProvider).submit(
            o,
            me.uid,
            decision: _decision,
            checks: [for (final c in _checks) c ?? true],
            weighedKg: _weighed,
            acceptKg: switch (_mode) {
              _Mode.partial => _acceptKg,
              _Mode.cancel => 0,
              _Mode.check => _weighed,
            },
            reason: _reason,
            photos: urls,
          );
      if (!mounted) return;
      context.pushReplacement(Routes.inspSent(o.id));
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
    final o = ref.watch(orderProvider(widget.orderId)).value;
    final x = ref.watch(inspectionProvider(widget.orderId)).value;
    if (o == null || x == null) return _loading(l.qcTitle(''));
    if (!_filled) {
      _filled = true;
      _kg.text = '${o.quantityKg}';
    }
    final title = switch (_mode) {
      _Mode.check => l.qcTitle(o.farmerName),
      _Mode.partial => l.partialTitle(o.farmerName),
      _Mode.cancel => l.cancelLoadTitle(o.farmerName),
    };
    final labels = checklistLabels(context, o.cropKey, o.grade);

    Widget photoBox(List<File> list, String label) => KsUploadBox(
          label: label,
          file: list.isEmpty ? null : list.last,
          height: list.isEmpty ? KsUploadBox.defaultHeight : KsUploadBox.previewHeight,
          onTap: list.length >= _maxPhotos
              ? () {}
              : () async {
                  final f = await pickPhoto(context);
                  if (f != null) setState(() => list.add(f));
                },
        );

    Widget reasonPills() => Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final r in RejectReason.values)
              KsPill(
                  label: reasonLabel(l, r),
                  selected: _reason == r,
                  onTap: () => setState(() => _reason = r)),
          ],
        );

    final weighText = l.scaleWeight(qtyText(context, _weighed));
    final body = switch (_mode) {
      _Mode.check => [
          Text(l.gradeChecklist(o.grade), style: AppTypography.bodyMediumStrong.normal),
          for (var i = 0; i < labels.length; i++) ...[
            const SizedBox(height: AppSpacing.block),
            Row(children: [
              Expanded(child: Text(labels[i], style: AppTypography.bodyMedium.normal)),
              KsPill(
                  label: l.chkOk,
                  selected: _checks[i] == true,
                  onTap: () => setState(() => _checks[i] = true)),
              const SizedBox(width: AppSpacing.sm),
              KsPill(
                  label: l.chkProblem,
                  selected: _checks[i] == false,
                  onTap: () => setState(() => _checks[i] = false)),
            ]),
          ],
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: l.rowDigitalWeight,
            controller: _kg,
            suffixText: l.unitKg,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.block),
          photoBox(_photos,
              l.goodsPhotos(Fmt.digits(context, '${_photos.length}'),
                  Fmt.digits(context, '$_maxPhotos'))),
          const SizedBox(height: AppSpacing.block),
          Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
            for (final d in InspectionDecision.values)
              KsPill(
                label: switch (d) {
                  InspectionDecision.approve => l.decApprove,
                  InspectionDecision.partial => l.decPartialTake,
                  InspectionDecision.cancel => l.decCancel,
                },
                selected: _decision == d,
                onTap: () => setState(() {
                  _decision = d;
                  _err = null;
                  if (d == InspectionDecision.partial) {
                    _mode = _Mode.partial;
                  } else if (d == InspectionDecision.cancel) {
                    _mode = _Mode.cancel;
                  }
                }),
              ),
          ]),
          const SizedBox(height: AppSpacing.block),
          Text(l.qcNote,
              style: AppTypography.bodySmall.normal.withColor(AppColors.textSecondary)),
        ],
      _Mode.partial => [
          Text(l.howMuchTake, style: AppTypography.bodyMediumStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(l.rowDigitalWeight, weighText),
            KsInfoRow(l.rowLeftOut,
                qtyText(context, (_weighed - _acceptKg).clamp(0, _weighed))),
          ]),
          const SizedBox(height: AppSpacing.block),
          Text(l.howMuchGood, style: AppTypography.bodyMediumStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsTextField(
            label: '',
            hint: Fmt.number(context, _weighed),
            controller: _accept,
            suffixText: l.unitKg,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯.]'))],
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: AppSpacing.block),
          photoBox(_rejectPhotos,
              l.rejectPhotos(Fmt.digits(context, '${_rejectPhotos.length}'),
                  Fmt.digits(context, '$_maxPhotos'))),
          const SizedBox(height: AppSpacing.block),
          reasonPills(),
          const SizedBox(height: AppSpacing.block),
          Text(l.partialNote(qtyText(context, _acceptKg)),
              style: AppTypography.bodySmall.normal.withColor(AppColors.textSecondary)),
        ],
      _Mode.cancel => [
          Text(l.whyCancel, style: AppTypography.bodyMediumStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(l.rowDigitalWeight, weighText),
            KsInfoRow(l.rowWillLoad, qtyText(context, 0)),
          ]),
          const SizedBox(height: AppSpacing.block),
          photoBox(_photos,
              l.goodsPhotos(Fmt.digits(context, '${_photos.length}'),
                  Fmt.digits(context, '$_maxPhotos'))),
          const SizedBox(height: AppSpacing.block),
          reasonPills(),
          const SizedBox(height: AppSpacing.block),
          Text(l.cancelLoadNote,
              style: AppTypography.bodySmall.normal.withColor(AppColors.textSecondary)),
        ],
    };

    return PopScope(
      canPop: _mode == _Mode.check,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          setState(() {
            _mode = _Mode.check;
            _decision = InspectionDecision.approve;
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        appBar: KsAppBar(
          title: title,
          onBack: _mode == _Mode.check
              ? null
              : () => setState(() {
                    _mode = _Mode.check;
                    _decision = InspectionDecision.approve;
                  }),
        ),
        body: ListView(
          padding: _pad,
          children: [
            ...body,
            if (_err != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_err!,
                  style: AppTypography.caption.normal.withColor(AppColors.textError)),
            ],
            const SizedBox(height: _gapBeforeCta),
            KsButton(
              label: _mode == _Mode.cancel ? l.cancelLoadBtn : l.submitReport,
              loading: _busy,
              onPressed: () => _submit(o),
            ),
          ],
        ),
      ),
    );
  }
}

/// 92-S / 93-S / 94-S Report Sent (Figma 500:6398 / 6432 / 6466).
class ReportSentScreen extends ConsumerWidget {
  const ReportSentScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final x = ref.watch(inspectionProvider(orderId)).value;
    final o = ref.watch(orderProvider(orderId)).value;
    if (x == null) return _loading(l.reportSentTitle);
    final d = x.decision ?? InspectionDecision.approve;
    final w = x.weighedKg ?? o?.quantityKg ?? 0;
    final a = x.acceptKg ?? w;
    final list = ref.watch(myInvitesProvider).value ?? const <Inspection>[];
    final idx = list.indexWhere((i) => i.orderId == orderId);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.reportSentTitle, showBack: false),
      body: ListView(
        padding: _pad,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.asset(AppImages.scale,
                height: _heroH, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.block),
          Text(x.done ? l.reportReachedBuyer : l.inspClosed,
              textAlign: TextAlign.center,
              style: AppTypography.headingBold22.normal),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            KsInfoRow(
                l.rowStop,
                l.stopLine(Fmt.digits(context, '${idx < 0 ? 1 : idx + 1}'),
                    Fmt.digits(context, '${list.isEmpty ? 1 : list.length}'),
                    x.farmerName)),
            if (x.done)
              KsInfoRow(
                  l.rowDecision,
                  switch (d) {
                    InspectionDecision.approve => l.decApproveLine(
                        Fmt.digits(context, '${x.okCount}'),
                        Fmt.digits(context, '${x.checks.length}')),
                    InspectionDecision.partial =>
                      l.decPartialLine(qtyText(context, a)),
                    InspectionDecision.cancel =>
                      l.decCancelLine(reasonLabel(l, x.reason)),
                  }),
            if (x.done)
              KsInfoRow(
                  l.rowWeight,
                  switch (d) {
                    InspectionDecision.approve => qtyText(context, w),
                    InspectionDecision.partial => l.weightLeftOut(
                        qtyText(context, w), qtyText(context, w - a)),
                    InspectionDecision.cancel => l.weightNoneTaken(qtyText(context, w)),
                  }),
            if (x.doneAt != null) KsInfoRow(l.rowTime, l10nTime(context, x.doneAt!)),
          ]),
          if (x.done) ...[
            const SizedBox(height: AppSpacing.block),
            KsNoteBox(
              warning: true,
              title: l.whatNext,
              body: switch (d) {
                InspectionDecision.approve => l.nextApprove,
                InspectionDecision.partial => l.nextPartial(qtyText(context, a)),
                InspectionDecision.cancel => l.nextCancel,
              },
            ),
          ],
          const SizedBox(height: _gapBeforeCta),
          KsButton(
            label: l.nextPickups,
            onPressed: () => context.canPop()
                ? context.pop()
                : context.go(Routes.inspector),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Buyer: report ─────────────────────────

/// 92 / 93 / 94 Inspection Report (buyer) or, with no inspector, 95 / 95-S
/// Load Record.
class LoadReportScreen extends ConsumerWidget {
  const LoadReportScreen({super.key, required this.orderId});
  final String orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final lang = Localizations.localeOf(context).languageCode;
    final o = ref.watch(orderProvider(orderId)).value;
    final xAsync = ref.watch(inspectionProvider(orderId));
    if (o == null || xAsync.isLoading) return _loading(l.inspReportTitle);
    final x = xAsync.value;
    final inspected = x != null && x.done;
    final d = x?.decision ?? InspectionDecision.approve;
    final ordered = o.orderedKg ?? o.quantityKg;
    final farmer = ref.watch(userByIdProvider(o.farmerId)).value;
    String tk(num v) => Fmt.taka(context, v);
    final fee = TradeRepository.platformFeePct;

    // Amounts for a partial: what was kept vs what comes back.
    final takeKg = x?.acceptKg ?? o.quantityKg;
    final farmerGets = o.timeline.containsKey('pickedUp')
        ? o.cropTotal
        : takeKg * o.pricePerKg;
    final cropBack = (ordered - takeKg) * o.pricePerKg;
    final feeBack = (cropBack * fee / 100).round();

    final (badge, bg, fg) = !inspected
        ? (l.loadDoneBadge, AppColors.bgSuccessSubtle, AppColors.textSuccess)
        : switch (d) {
            InspectionDecision.approve =>
              (l.decApproved, AppColors.bgSuccessSubtle, AppColors.textSuccess),
            InspectionDecision.partial =>
              (l.decPartial, AppColors.bgWarningSubtle, AppColors.textWarning),
            InspectionDecision.cancel =>
              (l.decCancel, AppColors.bgErrorSubtle, AppColors.textError),
          };
    final at = x?.doneAt ?? o.timeline['pickedUp'];
    final self = o.transportMode == TransportMode.self;
    final photo = (x?.photos.isNotEmpty ?? false)
        ? x!.photos.first
        : (o.loadPhotos.isNotEmpty ? o.loadPhotos.first : null);

    final rows = <Widget>[
      if (!inspected || d == InspectionDecision.approve || d == InspectionDecision.cancel)
        KsInfoRow(l.rowInspector,
            inspected ? l.inspYours(x.inspectorName) : l.inspNotSent),
      if (!inspected || d == InspectionDecision.approve)
        KsInfoRow(l.rowTimePlace,
            at == null ? l.stepWaiting : l.nameDot(l10nTime(context, at), districtOf(context, o.pickup))),
      if (!inspected) ...[
        KsInfoRow(l.rowDigitalWeight, qtyText(context, o.quantityKg)),
        KsInfoRow(l.rowWeighedBy,
            self ? l.weighedBySelf : l.weighedByDriver(o.transporterName ?? '')),
        KsInfoRow(l.rowReceivedFarmer, tk(o.cropTotal)),
      ] else
        ...switch (d) {
          InspectionDecision.approve => [
              KsInfoRow(l.rowDigitalWeight, qtyText(context, x.weighedKg ?? o.quantityKg)),
              KsInfoRow(l.rowChecklist,
                  l.okOutOf(Fmt.digits(context, '${x.okCount}'),
                      Fmt.digits(context, '${x.checks.length}'))),
              KsInfoRow(l.rowDecision, l.decApprove),
              KsInfoRow(l.rowReceivedFarmer, tk(farmerGets)),
            ],
          InspectionDecision.partial => [
              KsInfoRow(l.rowTaken, qtyText(context, takeKg)),
              KsInfoRow(l.rowLeftOutPast,
                  l.leftOutWhy(qtyText(context, (x.weighedKg ?? ordered) - takeKg),
                      reasonLabel(l, x.reason))),
              KsInfoRow(l.rowReceivedFarmer, tk(farmerGets)),
              KsInfoRow(l.rowCropValueBack, tk(cropBack)),
              KsInfoRow(l.rowFeeRefund(Fmt.digits(context, '$fee')), tk(feeBack)),
              KsInfoRow(l.rowTotalRefund, tk(cropBack + feeBack), strong: true),
            ],
          InspectionDecision.cancel => [
              KsInfoRow(l.rowInspReason, l.reasonNotMet(reasonLabel(l, x.reason))),
              KsInfoRow(l.rowReceivedFarmer, tk(0)),
              KsInfoRow(l.rowCropValueBack, tk(o.cropTotal)),
              KsInfoRow(l.rowFeeRefund(Fmt.digits(context, '$fee')), tk(o.platformFee)),
              KsInfoRow(l.rowTotalRefund, tk(o.cropTotal + o.platformFee), strong: true),
            ],
        },
    ];

    final share = [
      inspected ? l.inspReportTitle : l.loadRecordTitle,
      l.traceOrderLine(o.orderNo, o.cropName(lang), qtyText(context, o.quantityKg)),
      l.nameDot(o.farmerName, badge),
      if (at != null) l10nTime(context, at),
      l.statementVerified,
    ].join('\n');

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: inspected ? l.inspReportTitle : l.loadRecordTitle),
      body: ListView(
        padding: _pad,
        children: [
          KsListItem(
            highlighted: true,
            thumb: KsNetImage(
              url: farmer?.photoUrl,
              thumbSize: KsListItem.thumbSize.round(),
              fallbackAsset: AppUi.avatarFarmer,
            ),
            title: l.nameDot(o.farmerName, o.cropName(lang)),
            subtitle: o.orderNo,
            badge: badge,
            badgeColor: bg,
            badgeTextColor: fg,
            showChevron: false,
          ),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: rows),
          const SizedBox(height: AppSpacing.block),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: SizedBox(
              height: _heroH,
              width: double.infinity,
              child: KsNetImage(url: photo, fallbackAsset: AppImages.scale),
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
            warning: true,
            title: !inspected
                ? l.yourResponsibility
                : switch (d) {
                    InspectionDecision.approve => l.reportIsProof,
                    InspectionDecision.partial => l.fareSame,
                    InspectionDecision.cancel => l.farePayYou,
                  },
            body: !inspected
                ? (self ? l.yourResponsibilitySelf : l.yourResponsibilityBody)
                : switch (d) {
                    InspectionDecision.approve => l.reportIsProofBody,
                    InspectionDecision.partial => l.fareSameBody(tk(o.transportFare)),
                    InspectionDecision.cancel => l.farePayYouBody(tk(o.transportFare)),
                  },
          ),
          const SizedBox(height: _gapBeforeCta),
          Row(children: [
            Expanded(
              child: KsButton.outline(
                  label: l.pdfShort,
                  onPressed: () => PdfService.share(
                        context,
                        title: inspected ? l.inspReportTitle : l.loadRecordTitle,
                        fileName: 'report-${o.orderNo}',
                        children: [
                          Text(l.nameDot(o.farmerName, o.cropName(lang)),
                              style: AppTypography.bodyMediumStrong.normal),
                          Text(l.nameDot(o.orderNo, badge),
                              style: AppTypography.caption.normal
                                  .withColor(fg)),
                          const SizedBox(height: AppSpacing.block),
                          KsInfoBox(children: rows),
                        ],
                      )),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: inspected && d != InspectionDecision.approve
                  ? KsButton(
                      label: l.seePayments,
                      onPressed: () => context.push(Routes.payments))
                  : KsButton(
                      label: l.shareNow,
                      onPressed: () =>
                          SharePlus.instance.share(ShareParams(text: share))),
            ),
          ]),
        ],
      ),
    );
  }
}

