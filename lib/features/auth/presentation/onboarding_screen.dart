import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_page_dots.dart';

/// 03–05 Onboarding (Figma 292:2570, 299:12376, 299:12393).
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pager = PageController();
  int _page = 0;

  /// Figma sizes below its 28px status bar (the phone's own bar is added).
  static const _heroH = 472.0 - 28;
  static const _shadeH = 120.0 - 28;

  /// Figma "Hero Space": the dots start below the photo.
  static const _heroSpace = 380.0;
  static const _images = [
    AppImages.farmerField,
    AppImages.handshake,
    AppImages.truckRoad,
  ];

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  void _finish() => ref.read(onboardingDoneProvider.notifier).complete();

  void _next() {
    if (_page == _images.length - 1) {
      _finish();
    } else {
      _pager.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  void _back() {
    if (_page > 0) {
      _pager.previousPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      // Back from the first page returns to language selection.
      ref.read(localeProvider.notifier).reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final titles = [l.onb1Title, l.onb2Title, l.onb3Title];
    final bodies = [l.onb1Body, l.onb2Body, l.onb3Body];

    final top = MediaQuery.of(context).padding.top;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        backgroundColor: AppColors.bgPage,
        extendBodyBehindAppBar: true,
        appBar: KsAppBar(onBack: _back, onImage: true),
        body: PageView.builder(
          controller: _pager,
          itemCount: _images.length,
          onPageChanged: (i) => setState(() => _page = i),
          itemBuilder: (_, i) => Stack(
            children: [
              // Full-bleed hero (bottom corners 24) with a dark top shade so
              // the white back arrow stays readable.
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppRadius.modal),
                ),
                child: Image.asset(
                  _images[i],
                  height: _heroH + top,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: _shadeH + top,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppColors.heroShade, AppColors.heroShadeEnd],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    top + AppSizes.appBarHeight + AppSpacing.contentTop,
                    AppSpacing.screen,
                    AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: _heroSpace),
                      const SizedBox(height: AppSpacing.block),
                      KsPageDots(count: _images.length, index: i),
                      const SizedBox(height: AppSpacing.block),
                      Text(
                        titles[i],
                        textAlign: TextAlign.center,
                        style: AppTypography.headingBold22.normal,
                      ),
                      const SizedBox(height: AppSpacing.block),
                      Text(
                        bodies[i],
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium.normal.withColor(
                          AppColors.textSecondary,
                        ),
                      ),
                      // gap 14 + Spacer(4) + gap 14, then buttons (Figma 03–05)
                      const SizedBox(
                        height:
                            AppSpacing.block + AppSpacing.xs + AppSpacing.block,
                      ),
                      KsButton(
                        label: i == _images.length - 1 ? l.onbStart : l.onbNext,
                        onPressed: _next,
                      ),
                      const SizedBox(height: AppSpacing.block),
                      KsButton.text(label: l.onbSkip, onPressed: _finish),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
