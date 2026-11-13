import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_option_card.dart';

/// 02 Language Selection (Figma 292:290).
class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  late String _code =
      ref.read(localeProvider)?.languageCode ?? 'bn'; // Figma: বাংলা selected

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final title = AppTypography.headingBold22.normal;
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
              AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
          child: Column(
            children: [
              const Spacer(),
              Text(l.langTitleBn, style: title, textAlign: TextAlign.center),
              Text(l.langTitleEn, style: title, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.block),
              KsOptionCard(
                image: const AssetImage(AppImages.langIcon),
                title: l.langBangla,
                subtitle: l.langBanglaSub,
                selected: _code == 'bn',
                onTap: () => setState(() => _code = 'bn'),
              ),
              const SizedBox(height: AppSpacing.block),
              KsOptionCard(
                image: const AssetImage(AppImages.langIcon),
                title: l.langEnglish,
                subtitle: l.langEnglishSub,
                selected: _code == 'en',
                onTap: () => setState(() => _code = 'en'),
              ),
              // gap 14 + Spacer(4) + gap 14
              const SizedBox(
                  height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
              KsButton(
                label: l.langContinue,
                onPressed: () =>
                    ref.read(localeProvider.notifier).set(Locale(_code)),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
