import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/presentation/simple_tabs.dart';
import '../../../shared/widgets/ks_bottom_nav.dart';
import '../../../shared/widgets/ks_toast.dart';
import '../../trade/presentation/orders_screens.dart';
import 'buyer_common.dart';
import 'buyer_home_screen.dart';
import 'marketplace_screen.dart';

/// Buyer area with HF/Bottom Nav / Buyer (Demand FAB) (292:246):
/// হোম · বাজার · (+ চাহিদা) · সংগ্রহ · প্রোফাইল.
class BuyerShell extends ConsumerWidget {
  const BuyerShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final index = ref.watch(buyerTabProvider);
    final pages = [
      const BuyerHomeScreen(),
      const MarketplaceScreen(),
      const OrdersTab(),
      const SimpleProfileTab(),
    ];
    return Scaffold(
      body: IndexedStack(index: index, children: pages),
      bottomNavigationBar: KsBottomNav(
        index: index,
        onTap: (i) => ref.read(buyerTabProvider.notifier).go(i),
        fabLabel: l.navDemand,
        // Post Demand (96–99) is Tier C.
        onFab: () => KsToast.comingSoon(context),
        items: [
          KsNavItem.images(l.navHome, AppUi.navOnHome, AppUi.navOffHome),
          KsNavItem.images(l.navMarket, AppUi.navOnMarket, AppUi.navOffMarket),
          KsNavItem.images(
              l.navCollect, AppUi.navOnOrders, AppUi.navOffOrders),
          KsNavItem.images(
              l.navProfile, AppUi.navOnProfile, AppUi.navOffProfile),
        ],
      ),
    );
  }
}
