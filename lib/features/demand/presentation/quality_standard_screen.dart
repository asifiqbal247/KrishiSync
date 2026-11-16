import 'package:material_ui/material_ui.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../../shared/widgets/ks_transport_widgets.dart';

/// Grade standards (built-in reference table, like the crop list; Asif's
/// choice 2026-11-16). One value per grade A / B / C where it changes.
int _byGrade(String grade, int a, int b, int c) =>
    switch (grade) { 'B' => b, 'C' => c, _ => a };

/// The five standard lines for a crop and grade: (label, value).
/// Shown on 97 and used as the inspector's checklist (89).
List<(String, String)> qualityStandardRows(
    BuildContext context, String cropKey, String grade) {
  final l = AppLocalizations.of(context);
  String n(int v) => Fmt.digits(context, '$v');
  int g(int a, int b, int c) => _byGrade(grade, a, b, c);

  final (size, color, ripe, pack) = switch (cropKey) {
    'tomato' => (
        l.stdSizeAcross(n(g(5, 4, 3))),
        l.stdColorRed(n(g(80, 60, 40))),
        l.stdRipeTomato,
        l.stdPackCrate(n(20)),
      ),
    'potato' => (
        l.stdSizeAcross(n(g(5, 4, 3))),
        l.stdColorPotato,
        l.stdRipePotato,
        l.stdPackSack(n(50)),
      ),
    'rice' => (
        l.stdSizeGrain(n(g(2, 5, 8))),
        l.stdColorPaddy,
        l.stdRipePaddy(n(g(14, 15, 16))),
        l.stdPackSack(n(40)),
      ),
    'eggplant' => (
        l.stdSizeLength(n(g(15, 12, 10))),
        l.stdColorEggplant,
        l.stdRipeEggplant,
        l.stdPackCrate(n(20)),
      ),
    'onion' => (
        l.stdSizeAcross(n(g(5, 4, 3))),
        l.stdColorOnion,
        l.stdRipeOnion,
        l.stdPackNet(n(40)),
      ),
    'chili' => (
        l.stdSizeLength(n(g(6, 5, 4))),
        l.stdColorChili,
        l.stdRipeChili,
        l.stdPackBag(n(10)),
      ),
    'mango' => (
        l.stdSizeGrams(n(g(250, 200, 150))),
        l.stdColorMango,
        l.stdRipeMango,
        l.stdPackCrate(n(20)),
      ),
    _ => (l.stdSizeEven, l.stdColorNatural, l.stdRipeMarket, l.stdPackClean),
  };
  return [
    (l.stdRowSize, size),
    (l.stdRowColor, color),
    (l.stdRowRipe, ripe),
    (l.stdRowDamage, l.stdDamagePct(n(g(5, 10, 20)))),
    (l.stdRowPack, pack),
  ];
}

/// 97 Buyer – Quality Standard (Figma 292:3143). Opened after choosing a
/// grade on Post Demand (96): "use this standard" returns true. With
/// [pick] false (farmer viewing a demand) there is no button.
class QualityStandardScreen extends StatelessWidget {
  const QualityStandardScreen({
    super.key,
    required this.cropKey,
    required this.cropName,
    required this.grade,
    this.pick = true,
  });

  final String cropKey;
  final String cropName;
  final String grade;
  final bool pick;

  static const _heroH = 96.0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final rows = qualityStandardRows(context, cropKey, grade);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(title: l.stdTitle),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(AppSpacing.screen,
            AppSpacing.contentTop, AppSpacing.screen, AppSpacing.lg),
        children: [
          Text(l.stdHeading(cropName, grade),
              style: AppTypography.bodyMediumStrong.normal),
          const SizedBox(height: AppSpacing.block),
          KsInfoBox(children: [
            for (final (k, v) in rows) KsInfoRow(k, v, strong: true),
          ]),
          const SizedBox(height: AppSpacing.block),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Image.asset(AppImages.scale,
                height: _heroH, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: AppSpacing.block),
          KsNoteBox(
              warning: true, title: l.stdWhenTitle, body: l.stdWhenBody),
          if (pick) ...[
            const SizedBox(
                height: AppSpacing.block + AppSpacing.xs + AppSpacing.block),
            KsButton(
              label: l.stdUse,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ],
      ),
    );
  }
}
