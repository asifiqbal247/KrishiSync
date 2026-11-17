import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/presentation/simple_tabs.dart';
import '../../../shared/widgets/ks_bottom_nav.dart';
import '../../../shared/widgets/ks_dialogs.dart';
import '../../auth/data/auth_repository.dart';
import '../data/live_location.dart';
import 'earnings_screen.dart';
import 'transporter_home_screen.dart';
import 'trip_screens.dart';

class TransporterTabController extends Notifier<int> {
  @override
  int build() {
    // Back to Home whenever the signed-in user changes.
    ref.watch(authStateProvider.select((u) => u.value?.uid));
    return 0;
  }

  void go(int i) => state = i;
}

final transporterTabProvider = NotifierProvider<TransporterTabController, int>(
  TransporterTabController.new,
);

/// Transporter area with HF/Bottom Nav / Transporter (Load FAB) (292:263):
/// হোম · ট্রিপ · (লোড) · আয় · প্রোফাইল.
class TransporterShell extends ConsumerWidget {
  const TransporterShell({super.key});

  static const _fabIcon = 28.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final index = ref.watch(transporterTabProvider);
    ref.listen(locationAskProvider, (_, ask) async {
      if (!ask) return;
      ref.read(locationAskProvider.notifier).done();
      final ok = await showKsConfirm(
        context,
        title: l.locAskTitle,
        body: l.locAskBody,
        noLabel: l.locAskLater,
        yesLabel: l.locAskAllow,
        positive: true,
      );
      if (!ok) return;
      await Geolocator.requestPermission();
      ref.invalidate(liveTrackerProvider);
    });
    final pages = [
      const TransporterHomeScreen(),
      const MyJobsScreen(),
      const EarningsScreen(),
      const SimpleProfileTab(),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: KsBottomNav(
        index: index,
        onTap: (i) => ref.read(transporterTabProvider.notifier).go(i),
        fabLabel: l.navLoad,
        fabIcon: SvgPicture.asset(
          AppIcons.loadBox,
          width: _fabIcon,
          height: _fabIcon,
        ),
        onFab: () => context.push(Routes.trLoads),
        items: [
          KsNavItem.images(l.navHome, AppUi.navOnHome, AppUi.navOffHome),
          KsNavItem.images(l.navTrip, AppUi.navOnTruck, AppUi.navOffTruck),
          KsNavItem.images(
            l.navEarnings,
            AppUi.navOnWallet,
            AppUi.navOffWallet,
          ),
          KsNavItem.images(
            l.navProfile,
            AppUi.navOnProfile,
            AppUi.navOffProfile,
          ),
        ],
      ),
    );
  }
}
