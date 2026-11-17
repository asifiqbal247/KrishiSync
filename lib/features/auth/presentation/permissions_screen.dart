import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/l10n/locale_controller.dart';
import '../../../core/theme/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_icon.dart';
import '../../../shared/widgets/ks_app_bar.dart';
import '../../../shared/widgets/ks_button.dart';
import '../../../shared/widgets/ks_list_item.dart';

/// 13 Permissions (Figma 292:2587): location, camera and notifications,
/// each with its reason. Shown once after login; "later" or back skips.
/// Android asks again where a feature needs it (map pin, photo, …).
class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsState();
}

class _PermissionsState extends ConsumerState<PermissionsScreen> {
  static const _all = [
    Permission.locationWhenInUse,
    Permission.camera,
    Permission.notification,
  ];
  final _granted = <Permission>{};
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    for (final p in _all) {
      if (await p.isGranted) _granted.add(p);
    }
    if (mounted) setState(() {});
  }

  Future<void> _ask(Permission p) async {
    if (_granted.contains(p)) return;
    final s = await p.request();
    if (s.isGranted && mounted) setState(() => _granted.add(p));
  }

  Future<void> _askAll() async {
    setState(() => _busy = true);
    try {
      final r = await _all
          .where((p) => !_granted.contains(p))
          .toList()
          .request();
      _granted.addAll([
        for (final e in r.entries)
          if (e.value.isGranted) e.key,
      ]);
    } finally {
      // The router moves on to the next sign-up step.
      await ref.read(permissionsAskedProvider.notifier).done();
    }
  }

  void _later() => ref.read(permissionsAskedProvider.notifier).done();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    Widget tile(String icon) => ColoredBox(
      color: AppColors.bgSubtle,
      child: Center(child: AppIcon(icon, color: AppColors.iconBrand)),
    );
    final rows = [
      (
        Permission.locationWhenInUse,
        AppIcons.location,
        l.permLocation,
        l.permLocationWhy,
      ),
      (Permission.camera, AppIcons.camera, l.permCamera, l.permCameraWhy),
      (Permission.notification, AppIcons.bell, l.permNotif, l.permNotifWhy),
    ];
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      appBar: KsAppBar(onBack: _later),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.contentTop,
          AppSpacing.screen,
          AppSpacing.lg,
        ),
        children: [
          Text(l.permTitle, style: AppTypography.headingBold22.normal),
          const SizedBox(height: AppSpacing.block),
          Text(
            l.permSub,
            style: AppTypography.bodySmall.normal.withColor(
              AppColors.textSecondary,
            ),
          ),
          for (final (p, icon, title, why) in rows) ...[
            const SizedBox(height: AppSpacing.block),
            KsListItem(
              thumb: tile(icon),
              title: title,
              subtitle: why,
              subtitleMaxLines: 2,
              trailingText: _granted.contains(p) ? l.permGiven : l.permAllow,
              showChevron: false,
              onTap: () => _ask(p),
            ),
          ],
          const SizedBox(
            height: AppSpacing.block + AppSpacing.xs + AppSpacing.block,
          ),
          KsButton(label: l.permAllowAll, loading: _busy, onPressed: _askAll),
          const SizedBox(height: AppSpacing.block),
          KsButton.text(label: l.permLater, onPressed: _later),
        ],
      ),
    );
  }
}
