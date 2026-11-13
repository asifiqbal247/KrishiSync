import 'package:cached_network_image/cached_network_image.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../l10n/app_localizations.dart';
import 'app_icon.dart';

/// HF/Home Header (292:37): h 76, px 16, gap 10. Greeting Regular 14, name
/// Bold 20, 40px subtle circles with 20px brand bell / chat, 40px avatar.
class KsHomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const KsHomeHeader({
    super.key,
    required this.name,
    this.photoUrl,
    this.fallbackAvatar = AppUi.avatarFarmer,
    required this.onBell,
    required this.onChat,
    required this.onAvatar,
  });

  final String name;
  final String? photoUrl;
  final String fallbackAvatar;
  final VoidCallback onBell;
  final VoidCallback onChat;
  final VoidCallback onAvatar;

  static const _height = 76.0;
  static const _circle = 40.0;
  static const _icon = 20.0;
  static const _gap = 10.0;

  @override
  Size get preferredSize => const Size.fromHeight(_height);

  static String greeting(AppLocalizations l, DateTime now) {
    final h = now.hour;
    if (h >= 5 && h < 12) return l.greetingMorning;
    if (h >= 12 && h < 17) return l.greetingAfternoon;
    return l.greetingEvening;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Material(
      color: AppColors.bgPage,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: _height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screen),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(greeting(l, DateTime.now()),
                          style: AppTypography.bodyMedium.normal),
                      const SizedBox(height: AppSpacing.s2xs),
                      Text(name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.headingBold20.normal),
                    ],
                  ),
                ),
                const SizedBox(width: _gap),
                _circleIcon(AppIcons.bell, onBell),
                const SizedBox(width: _gap),
                _circleIcon(AppIcons.chat, onChat),
                const SizedBox(width: _gap),
                GestureDetector(
                  onTap: onAvatar,
                  child: ClipOval(
                    child: SizedBox.square(
                      dimension: _circle,
                      child: photoUrl == null
                          ? Image.asset(fallbackAvatar, fit: BoxFit.cover)
                          : CachedNetworkImage(
                              imageUrl: photoUrl!,
                              fit: BoxFit.cover,
                              errorWidget: (_, _, _) =>
                                  Image.asset(fallbackAvatar),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleIcon(String asset, VoidCallback onTap) => Material(
        color: AppColors.bgSubtle,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox.square(
            dimension: _circle,
            child: Center(
              child: AppIcon(asset, size: _icon, color: AppColors.iconBrand),
            ),
          ),
        ),
      );
}
