import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';

/// 01 Splash (Figma 292:280).
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const _contentTop = 96.0;
  static const _logoW = 160.0;
  static const _logoH = 156.0;
  static const _artAspect = 2 / 3; // 1024×1536 art, 360×540 in frame
  static const _fadeHeight = 140.0;
  static const _version = '1.0';

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Splash Art, anchored to the bottom (top 260 / h 540 in 800 frame).
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AspectRatio(
              aspectRatio: _artAspect,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(AppImages.splashIllustrationThreeUsers,
                      fit: BoxFit.cover),
                  // Splash Fade: white → transparent, 140 high, at art top.
                  const Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      height: _fadeHeight,
                      width: double.infinity,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [AppColors.white, AppColors.whiteTransparent],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
                  _contentTop, AppSpacing.screen, AppSpacing.lg),
              child: Column(
                children: [
                  Image.asset(AppImages.logo, width: _logoW, height: _logoH),
                  const SizedBox(height: AppSpacing.md),
                  Text(l.appName,
                      style: AppTypography.display28.normal
                          .withColor(AppColors.textBrand)),
                  const SizedBox(height: AppSpacing.md),
                  Text(l.splashTagline, style: AppTypography.bodyMedium.normal),
                  const Spacer(),
                  Text(
                    l.splashVersion(Fmt.digits(context, _version)),
                    textAlign: TextAlign.center,
                    style: AppTypography.caption.normal.copyWith(
                      color: AppColors.textOnBrand,
                      shadows: const [
                        Shadow(
                            color: AppColors.splashTextShadow,
                            offset: Offset(0, 1),
                            blurRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
