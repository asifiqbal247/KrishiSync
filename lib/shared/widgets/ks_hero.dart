import 'package:material_ui/material_ui.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';

/// Figma's 28px status bar; the phone's own status bar replaces it.
const _figmaStatusBar = 28.0;

/// Full-bleed hero photo behind a transparent app bar (Figma 03, 06, 23,
/// 36, 53, 75, 143, 144, 156): square corners, edge to edge.
///
/// Put it first in the scrolling content (no side padding); the content
/// starts [gap] below it. Use with `extendBodyBehindAppBar: true`,
/// `KsAppBar(onImage: true)` and a [KsHeroShade] over the scroll view.
class KsHeroPhoto extends StatelessWidget {
  const KsHeroPhoto({
    super.key,
    required this.image,
    required this.figmaHeight,
  });

  /// The photo (asset or network), shown with BoxFit.cover.
  final Widget image;

  /// Photo height as in Figma, including its status bar.
  final double figmaHeight;

  /// Figma: content padding 8 + "Hero Space" + gap 14 → 14 below the photo.
  static const gap = AppSpacing.block;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: figmaHeight - _figmaStatusBar + MediaQuery.of(context).padding.top,
    width: double.infinity,
    child: image,
  );
}

/// Dark top shade (Figma "Top Shade") so the white back arrow and title
/// stay readable. Stays fixed at the top while the page scrolls.
class KsHeroShade extends StatelessWidget {
  const KsHeroShade({super.key, this.figmaHeight = 120});

  /// Shade height as in Figma (120, or 140 on the transporter screens).
  final double figmaHeight;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      height:
          figmaHeight - _figmaStatusBar + MediaQuery.of(context).padding.top,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.heroShade, AppColors.heroShadeEnd],
        ),
      ),
    ),
  );
}

/// Room kept around map pins when a route map is the hero: the top part
/// sits under the status bar and the transparent app bar.
EdgeInsets heroMapFit(BuildContext context) {
  const pad = AppSpacing.s2xl;
  return EdgeInsets.fromLTRB(
    pad,
    MediaQuery.of(context).padding.top + AppSizes.appBarHeight + pad,
    pad,
    pad,
  );
}
