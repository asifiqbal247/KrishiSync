import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import 'app_icon.dart';

/// HF/Image Placeholder used as a map (12, 19, 98): square corners. Shows an
/// OpenStreetMap tile view with a brand pin when a point is known,
/// otherwise the Figma map art.
class KsMapPreview extends StatelessWidget {
  const KsMapPreview({
    super.key,
    required this.height,
    this.point,
    this.onTap,
    this.interactive = false,
  });

  final double height;
  final LatLng? point;
  final void Function(LatLng)? onTap;
  final bool interactive;

  static const _zoom = 13.0;
  static const _pin = 28.0;
  static const tileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const userAgent = 'com.asif.krishisync';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.photo),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: point == null
            ? Image.asset(AppImages.mapStrip, fit: BoxFit.cover)
            : FlutterMap(
                key: ValueKey(point),
                options: MapOptions(
                  initialCenter: point!,
                  initialZoom: _zoom,
                  interactionOptions: InteractionOptions(
                    flags: interactive
                        ? InteractiveFlag.all & ~InteractiveFlag.rotate
                        : InteractiveFlag.none,
                  ),
                  onTap: onTap == null ? null : (_, p) => onTap!(p),
                ),
                children: [
                  TileLayer(
                    urlTemplate: tileUrl,
                    userAgentPackageName: userAgent,
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: point!,
                        width: _pin,
                        height: _pin,
                        alignment: Alignment.topCenter,
                        child: const AppIcon(
                          AppIcons.location,
                          size: _pin,
                          color: AppColors.iconBrand,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
