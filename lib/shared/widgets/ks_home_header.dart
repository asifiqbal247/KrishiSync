import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../core/l10n/formatters.dart';
import '../../features/trade/data/trade_repository.dart';
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

  /// Unread count badge on the bell: min 18 round, 2px ring, "9+" max.
  static const _badge = 18.0;
  static const _badgeRing = 2.0;
  static const _badgeOffset = -4.0;
  static const _badgeMax = 9;

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
                Consumer(
                  builder: (context, ref, _) => _bell(
                    context,
                    ref.watch(unreadNotificationCountProvider),
                  ),
                ),
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

  /// Bell with the unread count (hidden at 0).
  Widget _bell(BuildContext context, int unread) => Semantics(
        label: unread > 0
            ? AppLocalizations.of(context).unreadNotifications(unread)
            : null,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _circleIcon(AppIcons.bell, onBell),
            if (unread > 0)
              Positioned(
                top: _badgeOffset,
                right: _badgeOffset,
                child: IgnorePointer(
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: _badge + _badgeRing * 2,
                      minHeight: _badge + _badgeRing * 2,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs + _badgeRing,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.countBadge,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: AppColors.countBadgeRing,
                        width: _badgeRing,
                      ),
                    ),
                    child: Text(
                      unread > _badgeMax
                          ? Fmt.digits(context, '$_badgeMax+')
                          : Fmt.digits(context, '$unread'),
                      style: AppTypography.labelSmall.normal
                          .withColor(AppColors.countBadgeText),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

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
