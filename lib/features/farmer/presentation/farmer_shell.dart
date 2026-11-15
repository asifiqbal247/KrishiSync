import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../core/theme/app_assets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/presentation/simple_tabs.dart';
import '../../../shared/widgets/ks_bottom_nav.dart';
import '../../trade/presentation/orders_screens.dart';
import '../../buyer/presentation/marketplace_screen.dart';
import 'farmer_home_screen.dart';

/// Farmer area with HF/Bottom Nav / Farmer (Sell FAB) (292:225).
class FarmerShell extends StatefulWidget {
  const FarmerShell({super.key});

  @override
  State<FarmerShell> createState() => _FarmerShellState();
}

class _FarmerShellState extends State<FarmerShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final pages = [
      const FarmerHomeScreen(),
      // 28 Marketplace (farmers compare other listings' prices).
      MarketplaceScreen(onBack: () => setState(() => _index = 0)),
      const OrdersTab(),
      const SimpleProfileTab(),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: KsBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        fabLabel: l.navSell,
        onFab: () => context.push(Routes.farmerSell),
        items: [
          KsNavItem.images(l.navHome, AppUi.navOnHome, AppUi.navOffHome),
          KsNavItem.images(l.navMarket, AppUi.navOnMarket, AppUi.navOffMarket),
          KsNavItem.images(l.navOrders, AppUi.navOnOrders, AppUi.navOffOrders),
          KsNavItem.images(
              l.navProfile, AppUi.navOnProfile, AppUi.navOffProfile),
        ],
      ),
    );
  }
}
