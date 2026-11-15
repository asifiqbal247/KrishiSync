import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import 'app_icon.dart';
import 'ks_list_item.dart';
import 'ks_map_preview.dart';
import 'ks_search_bar.dart';

LatLng? _ll(GeoPoint? g) => g == null ? null : LatLng(g.latitude, g.longitude);

/// Route map (Figma 117/143/144/159 map image, radius 16): OSM tiles with
/// pickup → drop line and pins. Falls back to the Figma map art when the
/// points are unknown. [points] adds extra pins (Available Loads, 143).
class KsRouteMap extends StatelessWidget {
  const KsRouteMap({
    super.key,
    required this.height,
    this.from,
    this.to,
    this.points = const [],
    this.onTap,
  });

  final double height;
  final GeoPoint? from;
  final GeoPoint? to;
  final List<GeoPoint> points;
  final VoidCallback? onTap;

  static const _pin = 28.0;
  static const _line = 4.0;
  static const _pad = 28.0;

  Marker _marker(LatLng p) => Marker(
        point: p,
        width: _pin,
        height: _pin,
        alignment: Alignment.topCenter,
        child: const AppIcon(AppIcons.location,
            size: _pin, color: AppColors.iconBrand),
      );

  @override
  Widget build(BuildContext context) {
    final a = _ll(from);
    final b = _ll(to);
    final all = [?a, ?b, for (final p in points) ?_ll(p)];
    final map = all.isEmpty
        ? Image.asset(AppImages.mapStrip, fit: BoxFit.cover)
        : FlutterMap(
            key: ValueKey(all.join()),
            options: MapOptions(
              initialCenter: all.first,
              initialZoom: 12,
              initialCameraFit: all.length > 1
                  ? CameraFit.coordinates(
                      coordinates: all,
                      padding: const EdgeInsets.all(_pad),
                      maxZoom: 13)
                  : null,
              interactionOptions:
                  const InteractionOptions(flags: InteractiveFlag.none),
              onTap: onTap == null ? null : (_, _) => onTap!(),
            ),
            children: [
              TileLayer(
                  urlTemplate: KsMapPreview.tileUrl,
                  userAgentPackageName: KsMapPreview.userAgent),
              if (a != null && b != null)
                PolylineLayer(polylines: [
                  Polyline(
                      points: [a, b],
                      strokeWidth: _line,
                      color: AppColors.bgBrand),
                ]),
              MarkerLayer(markers: [for (final p in all) _marker(p)]),
            ],
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: SizedBox(height: height, width: double.infinity, child: map),
    );
  }
}

/// "Rule Note" box from 110: brand (subtle green, brand border) or
/// warning (yellow tint, yellow border). Padding 14/12, radius 12, gap 6.
class KsNoteBox extends StatelessWidget {
  const KsNoteBox({
    super.key,
    required this.title,
    this.body,
    this.warning = false,
    this.bigTitle = false,
  });

  final String title;
  final String? body;
  final bool warning;

  /// OTP note: SemiBold 20 brand title.
  final bool bigTitle;

  @override
  Widget build(BuildContext context) {
    final titleStyle = bigTitle
        ? AppTypography.h2.normal.withColor(AppColors.textBrand)
        : AppTypography.bodyMediumStrong.normal;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.block, vertical: AppSpacing.md),
      decoration: BoxDecoration(
        color: warning ? AppColors.bgWarningSubtle : AppColors.bgSubtle,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: warning ? AppColors.iconWarning : AppColors.borderBrand),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: titleStyle),
          if (body != null) ...[
            const SizedBox(height: AppSpacing.label),
            Text(body!, style: AppTypography.bodySmall.normal),
          ],
        ],
      ),
    );
  }
}

/// Stars row (111 / 169): 5 × 32px, gap 8, centered. Brand outline = on,
/// faint outline = off (Figma).
class KsStarRating extends StatelessWidget {
  const KsStarRating({super.key, required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  static const _size = 32.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 1; i <= 5; i++) ...[
          if (i > 1) const SizedBox(width: AppSpacing.sm),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onChanged(i),
            child: SvgPicture.asset(
              i <= value ? AppIcons.starOn : AppIcons.starOff,
              width: _size,
              height: _size,
            ),
          ),
        ],
      ],
    );
  }
}

/// Weekly earnings chart (141): bordered box 172 high, radius 12, 7 brand
/// bars (radius 4, max 90) with day labels (Regular 11, secondary).
class KsBarChart extends StatelessWidget {
  const KsBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.zoom = false,
  });

  final List<num> values;
  final List<String> labels;

  /// Price trend: bars start just below the lowest value so small changes
  /// are visible. Earnings keep a zero baseline.
  final bool zoom;

  static const _h = 172.0;
  static const _barMax = 90.0;
  static const _barMin = 4.0;
  static const _gap = 8.0;

  @override
  Widget build(BuildContext context) {
    final max = values.fold<num>(0, (a, v) => v > a ? v : a);
    final positive = values.where((v) => v > 0);
    final base = zoom && positive.isNotEmpty
        ? positive.reduce((a, b) => a < b ? a : b) * 0.9
        : 0;
    return Container(
      height: _h,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md - 1, AppSpacing.md - 1, AppSpacing.md - 1, AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const SizedBox(width: _gap),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: max <= base || values[i] <= 0
                        ? _barMin
                        : (_barMin +
                            (_barMax - _barMin) *
                                (values[i] - base) /
                                (max - base)),
                    decoration: BoxDecoration(
                      color: AppColors.bgBrand,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(labels[i],
                      maxLines: 1,
                      style: AppTypography.labelSmall.normal.copyWith(
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple list sheet for picking one option (vehicle type, route…),
/// same look as the union sheet on screen 12.
Future<T?> showKsOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required List<(T, String)> options,
  String? searchHint,
}) async {
  FocusManager.instance.primaryFocus?.unfocus();
  final q = TextEditingController();
  final r = await showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) {
        final term = q.text.trim().toLowerCase();
        final shown = term.isEmpty
            ? options
            : options.where((o) => o.$2.toLowerCase().contains(term)).toList();
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: searchHint == null ? 0.6 : 0.9,
          maxChildSize: 0.95,
          builder: (_, scroll) => Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen, AppSpacing.lg, AppSpacing.screen, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.h3.normal),
                const SizedBox(height: AppSpacing.md),
                if (searchHint != null) ...[
                  KsSearchBar(
                      hint: searchHint,
                      controller: q,
                      onChanged: (_) => setS(() {})),
                  const SizedBox(height: AppSpacing.md),
                ],
                Expanded(
                  child: ListView.separated(
                    controller: scroll,
                    padding: const EdgeInsets.only(bottom: AppSpacing.s2xl),
                    itemCount: shown.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.md),
                    itemBuilder: (_, i) => KsListItem(
                      title: shown[i].$2,
                      onTap: () => Navigator.pop(ctx, shown[i].$1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
  q.dispose();
  FocusManager.instance.primaryFocus?.unfocus();
  return r;
}
