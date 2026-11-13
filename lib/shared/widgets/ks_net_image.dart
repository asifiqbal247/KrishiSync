import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../services/image_storage_service.dart';

/// Network photo (Cloudinary) with caching, muted placeholder, and an
/// optional bundled fallback image (e.g. the crop's catalog picture).
class KsNetImage extends ConsumerWidget {
  const KsNetImage({
    super.key,
    required this.url,
    this.fallbackAsset,
    this.thumbSize,
    this.fit = BoxFit.cover,
  });

  final String? url;
  final String? fallbackAsset;

  /// When set, asks the image service for a square thumbnail of this size
  /// (device pixels are handled by the service).
  final int? thumbSize;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget fallback() => fallbackAsset == null
        ? const ColoredBox(color: AppColors.bgMuted)
        : Image.asset(fallbackAsset!, fit: fit);

    final u = url;
    if (u == null || u.isEmpty) return fallback();
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final finalUrl = thumbSize == null
        ? u
        : ref.read(imageStorageProvider).thumbnail(u,
            size: (thumbSize! * dpr).round());
    return CachedNetworkImage(
      imageUrl: finalUrl,
      fit: fit,
      placeholder: (_, _) => const ColoredBox(color: AppColors.bgMuted),
      errorWidget: (_, _, _) => fallback(),
    );
  }
}
