import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/image_storage_service.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_blocks.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_input.dart';
import '../../../shared/widgets/ks_list_item.dart';
import '../../../shared/widgets/ks_skeleton.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';
import '../../../shared/widgets/ks_upload_box.dart';
import '../../../shared/widgets/photo_source_sheet.dart';
import '../../auth/data/user_repository.dart';
import '../../auth/domain/app_user.dart';
import '../../transport/presentation/transport_common.dart';

const _pad = EdgeInsets.fromLTRB(
  AppSpacing.screen,
  AppSpacing.contentTop,
  AppSpacing.screen,
  AppSpacing.lg,
);

String verificationText(AppLocalizations l, VerificationStatus v) =>
    switch (v) {
      VerificationStatus.verified => l.verifyDone,
      VerificationStatus.pending => l.verifyPendingSub,
      VerificationStatus.rejected => l.verifyRejectedSub,
      VerificationStatus.none => l.verifyNoneSub,
    };

/// 69 NID Verification (farmer / transporter, Figma 292:884) and
/// 139 Business Verification (buyer, 292:1635). Photos go to Cloudinary;
/// users/{uid}.verification becomes "pending" for the moderator (M6).
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationState();
}

class _VerificationState extends ConsumerState<VerificationScreen> {
  final _nid = TextEditingController();
  final _bizName = TextEditingController();
  final _license = TextEditingController();
  final _tin = TextEditingController();
  UserLocation? _bizAddr;
  final Map<String, File> _photos = {};
  final Map<String, String?> _err = {};
  bool _busy = false;
  bool _filled = false;

  @override
  void dispose() {
    for (final c in [_nid, _bizName, _license, _tin]) {
      c.dispose();
    }
    super.dispose();
  }

  void _prefill(AppUser me) {
    if (_filled) return;
    _filled = true;
    _nid.text = me.nidNumber ?? '';
    _bizName.text = me.business?['name'] ?? '';
    _license.text = me.business?['licenseNo'] ?? '';
    _tin.text = me.business?['tin'] ?? '';
  }

  Future<void> _pick(String key) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final f = await pickPhoto(context);
    if (f != null) {
      setState(() {
        _photos[key] = f;
        _err[key] = null;
      });
    }
  }

  Future<void> _submit(AppUser me, bool business) async {
    final l = AppLocalizations.of(context);
    final keys = business ? ['license'] : ['nidFront', 'nidBack', 'selfie'];
    final nid = Fmt.latinDigits(_nid.text.trim());
    setState(() {
      _err.clear();
      if (business) {
        if (_bizName.text.trim().isEmpty) _err['name'] = l.commonRequired;
        if (_license.text.trim().isEmpty) _err['license#'] = l.commonRequired;
      } else if (!RegExp(r'^(\d{10}|\d{17})$').hasMatch(nid)) {
        _err['nid'] = l.errNid;
      }
      for (final k in keys) {
        if (_photos[k] == null && (me.verificationDocs[k] ?? '').isEmpty) {
          _err[k] = l.errPhotoNeeded;
        }
      }
    });
    if (_err.values.any((e) => e != null)) return;
    setState(() => _busy = true);
    try {
      final docs = {...me.verificationDocs};
      for (final k in keys) {
        final f = _photos[k];
        if (f != null) {
          docs[k] =
              (await ref
                      .read(imageStorageProvider)
                      .upload(
                        f,
                        kind: ImageKind.verification,
                        ownerUid: me.uid,
                      ))
                  .url;
        }
      }
      await ref.read(userRepositoryProvider).submitVerification(me.uid, {
        'verificationDocs': docs,
        if (!business) 'nidNumber': nid,
        if (business)
          'business': {
            'name': _bizName.text.trim(),
            'licenseNo': _license.text.trim(),
            'tin': Fmt.latinDigits(_tin.text.trim()),
          },
        if (business && _bizAddr != null) 'location': _bizAddr!.toMap(),
      });
      if (!mounted) return;
      KsToast.show(context, l.verifySent);
      context.pop();
    } catch (_) {
      if (mounted) KsToast.show(context, l.errorGeneric);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Widget _box(String key, String label, AppUser me) {
    final url = me.verificationDocs[key];
    final has = _photos[key] != null || (url ?? '').isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsUploadBox(
          label: label,
          file: _photos[key],
          networkUrl: _photos[key] == null ? url : null,
          height: has
            ? KsUploadBox.previewHeight
            : (key == 'selfie' ? KsUploadBox.defaultHeight : _boxH),
          onTap: () => _pick(key),
        ),
        if (_err[key] != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              _err[key]!,
              style: AppTypography.caption.withColor(AppColors.textError),
            ),
          ),
      ],
    );
  }

  /// Figma 69: the two NID boxes are 92 high, selfie 61.
  static const _boxH = 92.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    if (me == null) {
      return const Scaffold(body: KsSkeletonList(rows: 3));
    }
    _prefill(me);
    final business = me.role == UserRole.buyer;
    final digits = [FilteringTextInputFormatter.allow(RegExp(r'[0-9০-৯]'))];

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: business ? l.bizVerifyTitle : l.nidVerifyTitle),
      body: ListView(
        padding: _pad,
        children: [
          Text(
            business ? l.bizVerifyIntro : l.nidVerifyIntro,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.block),
          if (business) ...[
            KsTextField(
              label: l.bizName,
              controller: _bizName,
              errorText: _err['name'],
            ),
            const SizedBox(height: AppSpacing.block),
            KsSelectField(
              label: l.bizAddress,
              placeholder: l.bizAddressHint,
              value: _bizAddr == null ? null : placeFull(context, _bizAddr!),
              onTap: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                final loc = await context.push<UserLocation>(
                  Routes.locationPicker,
                );
                FocusManager.instance.primaryFocus?.unfocus();
                if (loc != null) setState(() => _bizAddr = loc);
              },
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.tradeLicense,
              hint: 'TRAD/DNCC/012345',
              controller: _license,
              errorText: _err['license#'],
            ),
            const SizedBox(height: AppSpacing.block),
            KsTextField(
              label: l.tinLabel,
              hint: l.tinHint,
              controller: _tin,
              keyboardType: TextInputType.number,
              inputFormatters: digits,
            ),
            const SizedBox(height: AppSpacing.block),
            _box('license', l.licensePhoto, me),
          ] else ...[
            KsTextField(
              label: l.nidNumberLabel,
              hint: l.nidNumberHint,
              controller: _nid,
              keyboardType: TextInputType.number,
              inputFormatters: digits,
              maxLength: 17,
              errorText: _err['nid'],
            ),
            const SizedBox(height: AppSpacing.block),
            _box('nidFront', l.nidFront, me),
            const SizedBox(height: AppSpacing.block),
            _box('nidBack', l.nidBack, me),
            const SizedBox(height: AppSpacing.block),
            _box('selfie', l.selfie, me),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(
            label: l.submitVerify,
            loading: _busy,
            onPressed: () => _submit(me, business),
          ),
        ],
      ),
    );
  }
}

/// One review (reviews/{orderId_from_to}).
class Review {
  const Review(this.fromUid, this.stars, this.tags, this.comment, this.at);
  final String fromUid;
  final int stars;
  final List<String> tags;
  final String comment;
  final DateTime? at;

  factory Review.fromMap(Map<String, dynamic> m) {
    return Review(
      m['fromUid'] as String? ?? '',
      (m['stars'] as num?)?.toInt() ?? 0,
      [for (final t in (m['tags'] as List<dynamic>? ?? const [])) '$t'],
      m['comment'] as String? ?? '',
      (m['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}

final reviewsForProvider = StreamProvider.family<List<Review>, String>(
  (ref, uid) => ref
      .watch(userRepositoryProvider)
      .watchReviewsFor(uid)
      .map((l) => [for (final m in l) Review.fromMap(m)]),
);

String _stars(int n) => '★' * n + '☆' * (5 - n);

String _tagLabel(AppLocalizations l, String t) => switch (t) {
  'good_quality' => l.tag_good_quality,
  'right_weight' => l.tag_right_weight,
  'on_time' => l.tag_on_time,
  'on_time_load' => l.tag_on_time_load,
  'correct_info' => l.tag_correct_info,
  'fast_pay' => l.tag_fast_pay,
  _ => t,
};

class _ReviewTile extends ConsumerWidget {
  const _ReviewTile(this.r);
  final Review r;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final from = ref.watch(userByIdProvider(r.fromUid)).value;
    final body = r.comment.isNotEmpty
        ? r.comment
        : r.tags.map((t) => _tagLabel(l, t)).join(', ');
    return KsListItem(
      title: from?.name ?? '',
      subtitle: [
        l.placeDate(
          _stars(r.stars),
          r.at == null ? '' : Fmt.date(context, r.at!),
        ),
        if (body.isNotEmpty) body,
      ].join('\n'),
      subtitleMaxLines: 3,
      showChevron: false,
    );
  }
}

/// 70 Farmer / 140 Buyer Ratings & Reviews (Figma 292:3681 / 292:3700).
/// [withVerification] = 195 Verification & Ratings (transporter, 292:1949).
class RatingsScreen extends ConsumerWidget {
  const RatingsScreen({super.key, this.withVerification = false});
  final bool withVerification;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final me = ref.watch(currentUserProvider).value;
    if (me == null) return const Scaffold(body: KsSkeletonList());
    final async = ref.watch(reviewsForProvider(me.uid));
    final avg = Fmt.number(context, me.ratingAvg, decimals: 1);
    final n = Fmt.digits(context, '${me.ratingCount}');
    void soon() => KsToast.comingSoon(context);

    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(
        title: withVerification ? l.verifyStatusTitle : l.ratingsTitle,
      ),
      body: ListView(
        padding: _pad,
        children: [
          if (withVerification) ...[
            KsListItem(
              title: l.drivingLicense,
              subtitle: l.comingSoon,
              onTap: soon,
            ),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              title: 'NID',
              subtitle: verificationText(l, me.verification),
              onTap: () => context.push(Routes.verification),
            ),
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              title: l.vehiclePapers,
              subtitle: l.comingSoon,
              onTap: soon,
            ),
            const SizedBox(height: AppSpacing.block),
            KsSectionHeader(title: l.ratingsTitle),
            const SizedBox(height: AppSpacing.block),
            Text(l.outOf5Count(avg, n), style: AppTypography.bold18.normal),
            const SizedBox(height: AppSpacing.block),
            Center(
              child: KsStarRating(
                value: me.ratingAvg.round(),
                onChanged: (_) {},
              ),
            ),
          ] else ...[
            Text(l.outOf5(avg), style: AppTypography.h1.normal),
            const SizedBox(height: AppSpacing.sm),
            Text(_stars(me.ratingAvg.round()), style: AppTypography.h2.normal),
            const SizedBox(height: AppSpacing.sm),
            Text(
              l.reviewsOnlyDone(n),
              style: AppTypography.bodySmall.normal.withColor(
                AppColors.textSecondary,
              ),
            ),
          ],
          ...switch (async) {
            AsyncData(value: final list) when list.isEmpty => [
              const SizedBox(height: AppSpacing.block),
              Text(
                l.noReviews,
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.normal.withColor(
                  AppColors.textSecondary,
                ),
              ),
            ],
            AsyncData(value: final list) => [
              for (final r in list) ...[
                const SizedBox(height: AppSpacing.block),
                _ReviewTile(r),
              ],
            ],
            AsyncError() => [Text(l.errorGeneric)],
            _ => [const KsSkeletonList(rows: 2, padded: false)],
          },
        ],
      ),
    );
  }
}
