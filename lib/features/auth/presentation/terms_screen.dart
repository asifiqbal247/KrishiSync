import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';

/// Terms and Privacy Policy (linked from Login 06). Not in Figma — same
/// theme: App Bar, Bold 22 heading, SemiBold 16 section titles, Regular 14.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final sections = [
      (l.termsS1Title, l.termsS1Body),
      (l.termsS2Title, l.termsS2Body),
      (l.termsS3Title, l.termsS3Body),
      (l.termsS4Title, l.termsS4Body),
      (l.termsS5Title, l.termsS5Body),
      (l.termsS6Title, l.termsS6Body),
      (l.termsS7Title, l.termsS7Body),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.termsTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.s2xl),
        children: [
          Text(l.termsUpdated,
              style: AppTypography.caption.normal
                  .withColor(AppColors.textSecondary)),
          for (final (title, body) in sections) ...[
            const SizedBox(height: AppSpacing.block),
            Text(title, style: AppTypography.h3.normal),
            const SizedBox(height: AppSpacing.sm),
            Text(body, style: AppTypography.bodyMedium.copyWith(height: 1.5)),
          ],
        ],
      ),
    );
  }
}
