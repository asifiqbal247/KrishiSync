import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/locale_controller.dart';
import '../features/auth/presentation/permissions_screen.dart';
import '../features/farmer/presentation/farmer_delivered_screen.dart';
import '../features/transport/presentation/shared_truck_screens.dart';
import '../features/farmer/data/trade_doc_repository.dart';
import '../features/farmer/presentation/trade_doc_screen.dart';
import '../features/admin/presentation/admin_orders_screen.dart';
import '../features/admin/presentation/admin_screens.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_repository.dart';
import '../features/auth/domain/app_user.dart';
import '../features/auth/presentation/language_screen.dart';
import '../features/auth/presentation/location_picker_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/onboarding_screen.dart';
import '../features/auth/presentation/otp_screen.dart';
import '../features/auth/presentation/profile_setup_screen.dart';
import '../features/auth/presentation/role_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/auth/presentation/suspended_screen.dart';
import '../features/auth/presentation/terms_screen.dart';
import '../features/buyer/presentation/procurement_screens.dart';
import '../features/buyer/presentation/supplier_screens.dart';
import '../features/buyer/presentation/buyer_listing_screen.dart';
import '../features/buyer/presentation/buyer_profile_screen.dart';
import '../features/buyer/presentation/buyer_shell.dart';
import '../features/buyer/presentation/farmer_profile_screen.dart';
import '../features/buyer/presentation/search_screen.dart';
import '../features/demand/presentation/demand_screens.dart';
import '../features/demand/presentation/pooling_screens.dart';
import '../features/farmer/presentation/farmer_shell.dart';
import '../features/farmer/presentation/guide_screens.dart';
import '../features/farmer/presentation/listing_details_screen.dart';
import '../features/farmer/presentation/my_listings_screen.dart';
import '../features/farmer/presentation/sell_crop_screen.dart';
import '../features/market/presentation/price_screens.dart';
import '../features/moderator/presentation/moderator_screens.dart';
import '../features/moderator/presentation/report_screens.dart';
import '../features/moderator/presentation/verify_screens.dart';
import '../features/profile/presentation/share_record_screen.dart';
import '../features/profile/presentation/verification_screens.dart';
import '../features/trade/presentation/make_offer_screen.dart';
import '../features/trade/presentation/negotiate_screen.dart';
import '../features/trade/presentation/notifications_screen.dart';
import '../features/trade/presentation/offers_screen.dart';
import '../features/trade/presentation/orders_screens.dart';
import '../features/trade/presentation/payment_screens.dart';
import '../features/trade/presentation/place_order_screen.dart';
import '../features/trade/presentation/safe_payment_screen.dart';
import '../features/transport/presentation/buyer_transport_screens.dart';
import '../features/transport/presentation/loads_screens.dart';
import '../features/transport/presentation/earnings_screen.dart';
import '../features/transport/presentation/nav_screens.dart';
import '../features/transport/presentation/rate_screens.dart';
import '../features/transport/presentation/return_load_screens.dart';
import '../features/transport/presentation/transporter_shell.dart';
import '../features/transport/presentation/transporter_profile_screen.dart';
import '../features/transport/presentation/trip_screens.dart';
import '../features/transport/presentation/vehicle_screen.dart';
import '../features/chat/presentation/chat_screens.dart';
import '../features/profile/presentation/payment_method_screens.dart';
import '../features/trade/presentation/history_screens.dart';
import '../features/contract/presentation/contract_screens.dart';
import '../features/transport/presentation/load_screens.dart';
import '../features/market/presentation/opportunity_screens.dart';
import '../features/inspection/data/inspection_repository.dart';
import '../features/inspection/presentation/inspection_screens.dart';
import '../features/trade/presentation/trace_screen.dart';

abstract final class Routes {
  static const splash = '/splash';
  static const language = '/language';
  static const onboarding = '/onboarding';
  static const login = '/login';
  static const otp = '/otp';
  static const role = '/role';
  static const profileSetup = '/profile-setup';
  static const locationPicker = '/location';
  static const terms = '/terms';

  // Shared: market prices (29/30), payments (56/124), receipt (58/125)
  static const marketPrices = '/prices';
  static String priceTrend(String crop) => '/prices/$crop';
  static const payments = '/payments';
  static const verification = '/verification';
  static const editProfile = '/profile/edit';
  static const messages = '/messages';
  static String chat(String id) => '/messages/$id';
  static const help = '/help';
  static const shareRecord = '/share-record';
  static const history = '/history';
  static const contracts = '/contracts';
  // Loading & weighing (45/48/51/52 farmer, 162 driver, 132–134 buyer).
  static String farmerLoad(String id) => '/load/$id';
  static String weightDiff(String id) => '/weight/$id';
  static String extraWeight(String id) => '/extra/$id';
  static String refund(String id) => '/refund/$id';
  static String track(String id) => '/track/$id';
  static const opportunities = '/opportunities';
  // Buyer's inspector (88–95).
  static const inspector = '/inspector';
  static String inspCheck(String id) => '/inspector/check/$id';
  static String inspSent(String id) => '/inspector/sent/$id';
  static String loadReport(String id) => '/inspection/$id';
  static const planning = '/planning';
  static String rescue(String id) => '/rescue/$id';
  static String trace(String id) => '/trace/$id';
  static const newContract = '/contracts/new';
  static String contractDetails(String id) => '/contracts/$id/details';
  static String contractStatus(String id) => '/contracts/$id';
  static const statement = '/history/statement';
  static const tips = '/tips';
  static String tip(int i) => '/tips/$i';
  static const globalBuyers = '/export';
  static const exportGuide = '/export/guide';
  static const paymentMethods = '/payment-methods';
  static const addPayout = '/payment-methods/add';
  static const addBank = '/payment-methods/bank';
  static String addWallet(String type) => '/payment-methods/wallet/$type';
  static String faq(int i) => '/help/$i';

  // Buyer demands (96–99) and farmer side (31–33).
  static const postDemand = '/demand/new';
  static const myDemands = '/demand/mine';
  static String demandOffers(String id) => '/demand/$id/offers';
  static String matching(String id) => '/demand/$id/match';
  static String pool(String id) => '/demand/$id/pool';
  static String purchaseOrder(String id) => '/demand/$id/po';
  static const buyerDemands = '/demands';
  static String demandDetails(String id) => '/demands/$id';
  static const ratings = '/ratings';
  static const verifyAndRatings = '/ratings?verify=1';
  static String userRatings(String uid) => '/ratings?uid=$uid';
  static String buyerTrack(String id) => '/buyer/track/$id';
  static String receipt(String orderId) => '/receipt/$orderId';
  // 13 Permissions (once, after login).
  static const permissions = '/permissions';
  static const suspended = '/suspended';
  // 53 / 54: farmer sees the delivery and rates the buyer.
  static String farmerDelivered(String orderId) => '/delivered/$orderId';
  static String farmerRateBuyer(String orderId) => '/delivered/$orderId/rate';
  // 180: driver's fare in safe payment.
  static String trPayStatus(String id) => '/transporter/pay/$id';
  // 155 Route map (multi-stop) and 156–158 navigation.
  static String trRoute(String id) => '/transporter/trip/$id/route';
  static String trNav(String id) => '/transporter/trip/$id/nav';

  static const farmerHome = '/farmer';
  static const buyerHome = '/buyer';
  static const transporterHome = '/transporter';
  static const moderatorHome = '/moderator';
  static const adminHome = '/admin';

  // Farmer
  static const farmerSell = '/farmer/sell';
  static const farmerListings = '/farmer/listings';
  static String farmerListingDetails(String id) => '/farmer/listings/$id';
  static String farmerEditListing(String id) => '/farmer/listings/$id/edit';

  // Buyer
  // Shared by farmer (28/17) and buyer (74/73).
  static const buyerSearch = '/search';
  static String buyerListing(String id) => '/listing/$id';
  static String buyerFarmer(String uid) => '/people/farmer/$uid';
  static const suppliers = '/suppliers';
  static const procurement = '/procurement';
  static const procurementAnalytics = '/procurement/analytics';
  static String supplier(String uid) => '/suppliers/$uid';
  // 207 Document viewer: a farmer's export paper (phyto | license).
  static String tradeDoc(String uid, String type) => '/documents/$uid/$type';
  static String transporterProfile(String uid, {bool pick = false}) =>
      '/people/transporter/$uid${pick ? '?pick=1' : ''}';
  static String buyerProfile(String uid) => '/people/buyer/$uid';

  // Trade (farmer + buyer)
  static String makeOffer(String listingId) => '/listing/$listingId/offer';
  static String listingOffers(String listingId) =>
      '/farmer/listings/$listingId/offers';
  static String offer(String id) => '/offer/$id';
  static String order(String id) => '/order/$id';
  static String placeOrder(String listingId, {String? offerId}) =>
      '/buyer/order/$listingId${offerId == null ? '' : '?offer=$offerId'}';
  static const notifications = '/notifications';

  // Buyer transport (Part 6)
  static const buyerTransport = '/buyer/transport';
  static String buyerBook(String deliveryId) => '/buyer/book/$deliveryId';
  static String buyerAssigned(String deliveryId) =>
      '/buyer/assigned/$deliveryId';
  static String buyerReceive(String deliveryId) => '/buyer/receive/$deliveryId';
  static String buyerRate(String orderId) => '/buyer/rate/$orderId';

  // Transporter
  static const trLoads = '/transporter/loads';
  static const trReturnLoads = '/transporter/return';
  // 161 / 150: loads for the free space on the running trip.
  static const trShared = '/transporter/shared';
  static String trSharedLoad(String id) => '/transporter/shared/$id';
  static String trReturnDone(String id) => '/transporter/return/$id';
  static String trLoad(String id) => '/transporter/load/$id';
  static String trFareOffer(String id) => '/transporter/load/$id/offer';
  static String trJob(String id) => '/transporter/job/$id';
  static String trTrip(String id) => '/transporter/trip/$id';
  static String trDeliver(String id) => '/transporter/trip/$id/deliver';
  static String trWeigh(String id) => '/transporter/trip/$id/weigh';
  static String trDone(String id) => '/transporter/trip/$id/done';
  static String trRate(String id) => '/transporter/trip/$id/rate';
  static const trVehicle = '/transporter/vehicle';

  static const safePayment = '/buyer/pay';
  static String report({String? orderId}) =>
      '/report${orderId == null ? '' : '?order=$orderId'}';

  // Moderator (Admin may open these too)
  static String moderatorReview(String id) => '/moderator/review/$id';
  static const moderatorQueue = '/moderator/queue';
  static const moderatorReports = '/moderator/reports';
  static String moderatorReport(String id) => '/moderator/report/$id';
  static const moderatorVerify = '/moderator/verify';
  static String moderatorVerifyUser(String uid) => '/moderator/verify/$uid';

  // Admin
  static String adminUser(String uid) => '/admin/user/$uid';
  static const adminCrops = '/admin/crops';
  static String adminOrders([String filter = 'all']) =>
      '/admin/orders?filter=$filter';

  static String homeFor(UserRole role) => switch (role) {
    UserRole.farmer => farmerHome,
    UserRole.buyer => buyerHome,
    UserRole.transporter => transporterHome,
    UserRole.moderator => moderatorHome,
    UserRole.admin => adminHome,
  };

  static const _preAuth = {splash, language, onboarding, login, otp};
  static bool isPreAuth(String loc) => _preAuth.contains(loc);
}

/// Splash stays visible at least this long (Figma 01).
final splashMinElapsedProvider = FutureProvider<void>(
  (_) => Future<void>.delayed(const Duration(milliseconds: 1500)),
);

/// Re-runs go_router redirects whenever auth / profile / prefs change.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    void ping(_, _) => notifyListeners();
    ref.listen(authStateProvider, ping);
    ref.listen(currentUserProvider, ping);
    ref.listen(myInvitesProvider, ping);
    ref.listen(localeProvider, ping);
    ref.listen(onboardingDoneProvider, ping);
    ref.listen(permissionsAskedProvider, ping);
    ref.listen(splashMinElapsedProvider, ping);
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  String? redirect(GoRouterState state) {
    final loc = state.matchedLocation;
    final splashDone = ref.read(splashMinElapsedProvider).hasValue;
    final auth = ref.read(authStateProvider);
    final user = ref.read(currentUserProvider);

    // 1. Still loading anything → splash.
    if (!splashDone || auth.isLoading) {
      return loc == Routes.splash ? null : Routes.splash;
    }
    // 2. Language not chosen.
    if (ref.read(localeProvider) == null) {
      return loc == Routes.language ? null : Routes.language;
    }
    // 3. Onboarding not seen.
    if (!ref.read(onboardingDoneProvider)) {
      return loc == Routes.onboarding ? null : Routes.onboarding;
    }
    // Terms page is open to everyone.
    if (loc == Routes.terms) return null;
    // 4. Signed out → login / otp only.
    final fbUser = auth.value;
    if (fbUser == null) {
      return (loc == Routes.login || loc == Routes.otp) ? null : Routes.login;
    }
    // 5. Signed in but profile doc still loading / being created.
    if (user.isLoading || user.value == null) {
      return loc == Routes.splash ? null : Routes.splash;
    }
    final u = user.value!;
    // 5a. Suspended by an admin: nothing but the suspended screen.
    if (u.isSuspended) {
      return loc == Routes.suspended ? null : Routes.suspended;
    }
    // 5b. 13 Permissions: once per phone, right after login.
    if (!ref.read(permissionsAskedProvider)) {
      return loc == Routes.permissions ? null : Routes.permissions;
    }
    // 6. No role yet. A person invited as a buyer's inspector (88) only
    //    sees the inspector screens.
    if (!u.hasRole) {
      final invites = ref.read(myInvitesProvider);
      if (invites.isLoading && !invites.hasValue) {
        return loc == Routes.splash ? null : Routes.splash;
      }
      if ((invites.value ?? const []).isNotEmpty) {
        return loc.startsWith(Routes.inspector) ? null : Routes.inspector;
      }
      return loc == Routes.role ? null : Routes.role;
    }
    // 7. Profile incomplete (location picker is part of that step).
    if (!u.profileComplete) {
      return (loc == Routes.profileSetup || loc == Routes.locationPicker)
          ? null
          : Routes.profileSetup;
    }
    // 7b. Transporter must add a vehicle first (194).
    if (u.role == UserRole.transporter && u.vehicle == null) {
      return (loc == Routes.trVehicle || loc == Routes.locationPicker)
          ? null
          : Routes.trVehicle;
    }
    // 8. Ready: leave auth screens for the role home.
    if (Routes.isPreAuth(loc) ||
        loc == Routes.permissions ||
        loc == Routes.suspended ||
        loc == Routes.role ||
        loc == Routes.profileSetup) {
      return Routes.homeFor(u.role!);
    }
    // 9. Block other roles' areas.
    final home = Routes.homeFor(u.role!);
    const areas = [
      Routes.farmerHome,
      Routes.buyerHome,
      Routes.transporterHome,
      Routes.moderatorHome,
      Routes.adminHome,
    ];
    for (final a in areas) {
      if (loc.startsWith(a) && a != home) {
        // Admin may open moderator screens.
        if (u.role == UserRole.admin && a == Routes.moderatorHome) continue;
        return home;
      }
    }
    return null;
  }

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (_, state) => redirect(state),
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.language, builder: (_, _) => const LanguageScreen()),
      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.otp, builder: (_, _) => const OtpScreen()),
      GoRoute(
        path: Routes.suspended,
        builder: (_, _) => const SuspendedScreen(),
      ),
      GoRoute(path: Routes.terms, builder: (_, _) => const TermsScreen()),
      GoRoute(
        path: Routes.marketPrices,
        builder: (_, _) => const MarketPricesScreen(),
        routes: [
          GoRoute(
            path: ':crop',
            builder: (_, s) =>
                PriceTrendScreen(cropKey: s.pathParameters['crop']!),
          ),
        ],
      ),
      GoRoute(path: Routes.payments, builder: (_, _) => const PaymentsScreen()),
      GoRoute(
        path: Routes.postDemand,
        builder: (_, _) => const PostDemandScreen(),
      ),
      GoRoute(
        path: Routes.myDemands,
        builder: (_, _) => const MyDemandsScreen(),
      ),
      GoRoute(
        path: '/demand/:id/match',
        builder: (_, s) => MatchingScreen(demandId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/demand/:id/pool',
        builder: (_, s) => PoolScreen(
          demandId: s.pathParameters['id']!,
          farmerIds: (s.extra as List<String>?) ?? const [],
        ),
      ),
      GoRoute(
        path: '/demand/:id/po',
        builder: (_, s) => PurchaseOrderScreen(
          demandId: s.pathParameters['id']!,
          farmerIds: (s.extra as List<String>?) ?? const [],
        ),
      ),
      GoRoute(
        path: '/demand/:id/offers',
        builder: (_, s) =>
            DemandOffersScreen(demandId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.buyerDemands,
        builder: (_, _) => const BuyerDemandsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) =>
                DemandDetailsScreen(demandId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.messages,
        builder: (_, _) => const MessagesScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => ChatScreen(chatId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.paymentMethods,
        builder: (_, _) => const PaymentMethodsScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (_, _) => const AddPaymentMethodScreen(),
          ),
          GoRoute(path: 'bank', builder: (_, _) => const AddBankScreen()),
          GoRoute(
            path: 'wallet/:type',
            builder: (_, s) => AddWalletScreen(type: s.pathParameters['type']!),
          ),
        ],
      ),
      GoRoute(path: Routes.tips, builder: (_, _) => const TipsListScreen()),
      GoRoute(
        path: '/tips/:i',
        builder: (_, s) =>
            TipScreen(index: int.tryParse(s.pathParameters['i']!) ?? 0),
      ),
      GoRoute(
        path: Routes.globalBuyers,
        builder: (_, _) => const GlobalBuyersScreen(),
        routes: [
          GoRoute(path: 'guide', builder: (_, _) => const ExportGuideScreen()),
        ],
      ),
      GoRoute(
        path: Routes.inspector,
        builder: (_, _) => const InspectorHomeScreen(),
        routes: [
          GoRoute(
            path: 'check/:id',
            builder: (_, s) =>
                QualityCheckScreen(orderId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'sent/:id',
            builder: (_, s) =>
                ReportSentScreen(orderId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/inspection/:id',
        builder: (_, s) => LoadReportScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.opportunities,
        builder: (_, _) => const OpportunityFeedScreen(),
      ),
      GoRoute(path: Routes.planning, builder: (_, _) => const PlanningScreen()),
      GoRoute(
        path: '/rescue/:id',
        builder: (_, s) =>
            SurplusRescueScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/trace/:id',
        builder: (_, s) => TraceScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/load/:id',
        builder: (_, s) => FarmerLoadScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/weight/:id',
        builder: (_, s) => WeightLessScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/extra/:id',
        builder: (_, s) => ExtraWeightScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/refund/:id',
        builder: (_, s) => RefundScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/track/:id',
        builder: (_, s) => TrackingScreen(deliveryId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: Routes.contracts,
        builder: (_, _) => const ContractsScreen(),
        routes: [
          GoRoute(path: 'new', builder: (_, _) => const NewContractScreen()),
          GoRoute(
            path: ':id',
            builder: (_, s) =>
                ContractStatusScreen(id: s.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'details',
                builder: (_, s) =>
                    ContractDetailsScreen(id: s.pathParameters['id']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.history,
        builder: (_, _) => const TransactionHistoryScreen(),
        routes: [
          GoRoute(
            path: 'statement',
            builder: (_, _) => const StatementScreen(),
          ),
        ],
      ),
      GoRoute(
        path: Routes.shareRecord,
        builder: (_, _) => const ShareRecordScreen(),
      ),
      GoRoute(
        path: Routes.help,
        builder: (_, _) => const HelpScreen(),
        routes: [
          GoRoute(
            path: ':i',
            builder: (_, s) =>
                FaqScreen(index: int.tryParse(s.pathParameters['i']!) ?? 0),
          ),
        ],
      ),
      GoRoute(
        path: Routes.editProfile,
        builder: (_, _) => const ProfileSetupScreen(editing: true),
      ),
      GoRoute(
        path: Routes.verification,
        builder: (_, _) => const VerificationScreen(),
      ),
      GoRoute(
        path: Routes.ratings,
        builder: (_, s) => RatingsScreen(
          withVerification: s.uri.queryParameters['verify'] == '1',
          uid: s.uri.queryParameters['uid'],
        ),
      ),
      GoRoute(
        path: '/receipt/:id',
        builder: (_, s) => ReceiptScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(path: Routes.role, builder: (_, _) => const RoleScreen()),
      GoRoute(
        path: Routes.permissions,
        builder: (_, _) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/delivered/:id',
        builder: (_, s) =>
            FarmerDeliveredScreen(orderId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'rate',
            builder: (_, s) =>
                RateBuyerScreen(orderId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.profileSetup,
        builder: (_, _) => const ProfileSetupScreen(),
      ),
      GoRoute(
        path: Routes.locationPicker,
        builder: (_, _) => const LocationPickerScreen(),
      ),
      GoRoute(
        path: Routes.farmerHome,
        builder: (_, _) => const FarmerShell(),
        routes: [
          GoRoute(path: 'sell', builder: (_, _) => const SellCropScreen()),
          GoRoute(
            path: 'listings',
            builder: (_, _) => const MyListingsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, s) =>
                    ListingDetailsScreen(listingId: s.pathParameters['id']!),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (_, s) =>
                        EditListingScreen(listingId: s.pathParameters['id']!),
                  ),
                  GoRoute(
                    path: 'offers',
                    builder: (_, s) =>
                        OffersScreen(listingId: s.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      // Shared by farmer and buyer (rules decide who may read).
      GoRoute(
        path: '/offer/:id',
        builder: (_, s) => NegotiateScreen(offerId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/order/:id',
        builder: (_, s) => OrderDetailsScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/search',
        builder: (_, s) => SearchScreen(initialQuery: s.extra as String?),
      ),
      GoRoute(
        path: '/listing/:id',
        builder: (_, s) =>
            BuyerListingScreen(listingId: s.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'offer',
            builder: (_, s) =>
                MakeOfferScreen(listingId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/people/farmer/:uid',
        builder: (_, s) =>
            FarmerProfileScreen(farmerId: s.pathParameters['uid']!),
      ),
      GoRoute(
        path: '/procurement',
        builder: (_, _) => const ProcurementDashboardScreen(),
        routes: [
          GoRoute(
            path: 'analytics',
            builder: (_, _) => const ProcurementAnalyticsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/documents/:uid/:type',
        builder: (_, s) => TradeDocScreen(
          uid: s.pathParameters['uid']!,
          type: TradeDocType.values.firstWhere(
            (t) => t.name == s.pathParameters['type'],
            orElse: () => TradeDocType.phyto,
          ),
        ),
      ),
      GoRoute(
        path: '/suppliers',
        builder: (_, _) => const SuppliersScreen(),
        routes: [
          GoRoute(
            path: ':uid',
            builder: (_, s) =>
                SupplierProfileScreen(farmerId: s.pathParameters['uid']!),
          ),
        ],
      ),
      GoRoute(
        path: '/people/transporter/:uid',
        builder: (_, s) => TransporterProfileScreen(
          uid: s.pathParameters['uid']!,
          pick: s.uri.queryParameters['pick'] == '1',
        ),
      ),
      GoRoute(
        path: '/people/buyer/:uid',
        builder: (_, s) => BuyerProfileScreen(uid: s.pathParameters['uid']!),
      ),
      GoRoute(
        path: Routes.notifications,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/report',
        builder: (_, s) =>
            ReportIssueScreen(orderId: s.uri.queryParameters['order']),
      ),
      GoRoute(
        path: Routes.moderatorHome,
        builder: (_, _) => const ModeratorShell(),
        routes: [
          GoRoute(
            path: 'review/:id',
            builder: (_, s) =>
                ListingReviewScreen(listingId: s.pathParameters['id']!),
          ),
          GoRoute(path: 'queue', builder: (_, _) => const ListingsQueuePage()),
          GoRoute(
            path: 'reports',
            builder: (_, _) => const ReportsQueue(showBack: true),
          ),
          GoRoute(
            path: 'report/:id',
            builder: (_, s) =>
                ReportDetailScreen(reportId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'verify',
            builder: (_, _) => const VerificationQueue(showBack: true),
            routes: [
              GoRoute(
                path: ':uid',
                builder: (_, s) =>
                    VerifyReviewScreen(uid: s.pathParameters['uid']!),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.adminHome,
        builder: (_, _) => const AdminShell(),
        routes: [
          GoRoute(
            path: 'user/:uid',
            builder: (_, s) => UserDetailScreen(uid: s.pathParameters['uid']!),
          ),
          GoRoute(path: 'crops', builder: (_, _) => const CropCatalogScreen()),
          GoRoute(
            path: 'orders',
            builder: (_, s) => AdminOrdersScreen(
              filter: s.uri.queryParameters['filter'] ?? 'all',
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.buyerHome,
        builder: (_, _) => const BuyerShell(),
        routes: [
          GoRoute(
            path: 'pay',
            builder: (_, s) => SafePaymentScreen(draft: s.extra! as OrderDraft),
          ),
          GoRoute(
            path: 'order/:listingId',
            builder: (_, s) => PlaceOrderScreen(
              listingId: s.pathParameters['listingId']!,
              offerId: s.uri.queryParameters['offer'],
            ),
          ),
          GoRoute(
            path: 'transport',
            builder: (_, _) => const BuyerTransportScreen(),
          ),
          GoRoute(
            path: 'book/:id',
            builder: (_, s) =>
                BookTruckScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'assigned/:id',
            builder: (_, s) =>
                AssignedTransportScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'track/:id',
            builder: (_, s) =>
                TrackingScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'receive/:id',
            builder: (_, s) =>
                ReceiveDeliveryScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'rate/:id',
            builder: (_, s) =>
                RateOrderScreen(orderId: s.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: Routes.transporterHome,
        builder: (_, _) => const TransporterShell(),
        routes: [
          GoRoute(
            path: 'shared',
            builder: (_, _) => const SharedTruckScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, s) =>
                    SharedLoadScreen(deliveryId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'return',
            builder: (_, _) => const ReturnLoadsScreen(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, s) =>
                    ReturnDoneScreen(deliveryId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'loads',
            builder: (_, s) =>
                LoadsScreen(returnOnly: s.uri.queryParameters['return'] == '1'),
          ),
          GoRoute(
            path: 'load/:id',
            builder: (_, s) =>
                LoadDetailsScreen(deliveryId: s.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'offer',
                builder: (_, s) =>
                    FareOfferScreen(deliveryId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(
            path: 'pay/:id',
            builder: (_, s) =>
                PayStatusScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'job/:id',
            builder: (_, s) =>
                PickupScheduleScreen(deliveryId: s.pathParameters['id']!),
          ),
          GoRoute(
            path: 'trip/:id',
            builder: (_, s) =>
                TripStatusScreen(deliveryId: s.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'route',
                builder: (_, s) =>
                    RouteMapScreen(deliveryId: s.pathParameters['id']!),
              ),
              GoRoute(
                path: 'nav',
                builder: (_, s) =>
                    NavigationScreen(deliveryId: s.pathParameters['id']!),
              ),
              GoRoute(
                path: 'deliver',
                builder: (_, s) =>
                    ProofOfDeliveryScreen(deliveryId: s.pathParameters['id']!),
              ),
              GoRoute(
                path: 'weigh',
                builder: (_, s) =>
                    LoadWeighScreen(deliveryId: s.pathParameters['id']!),
              ),
              GoRoute(
                path: 'done',
                builder: (_, s) =>
                    TripCompleteScreen(deliveryId: s.pathParameters['id']!),
              ),
              GoRoute(
                path: 'rate',
                builder: (_, s) =>
                    RateCustomerScreen(deliveryId: s.pathParameters['id']!),
              ),
            ],
          ),
          GoRoute(path: 'vehicle', builder: (_, _) => const VehicleScreen()),
        ],
      ),
    ],
  );
});
