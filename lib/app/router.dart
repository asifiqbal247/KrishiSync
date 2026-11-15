import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/locale_controller.dart';
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
import '../features/auth/presentation/terms_screen.dart';
import '../features/buyer/presentation/buyer_listing_screen.dart';
import '../features/buyer/presentation/buyer_profile_screen.dart';
import '../features/buyer/presentation/buyer_shell.dart';
import '../features/buyer/presentation/farmer_profile_screen.dart';
import '../features/buyer/presentation/search_screen.dart';
import '../features/demand/presentation/demand_screens.dart';
import '../features/farmer/presentation/farmer_shell.dart';
import '../features/farmer/presentation/listing_details_screen.dart';
import '../features/farmer/presentation/my_listings_screen.dart';
import '../features/farmer/presentation/sell_crop_screen.dart';
import '../features/market/presentation/price_screens.dart';
import '../features/moderator/presentation/moderator_screens.dart';
import '../features/moderator/presentation/report_screens.dart';
import '../features/moderator/presentation/verify_screens.dart';
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
import '../features/transport/presentation/rate_screens.dart';
import '../features/transport/presentation/transporter_shell.dart';
import '../features/transport/presentation/trip_screens.dart';
import '../features/transport/presentation/vehicle_screen.dart';
import '../features/chat/presentation/chat_screens.dart';

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
  static String faq(int i) => '/help/$i';

  // Buyer demands (96–99) and farmer side (31–33).
  static const postDemand = '/demand/new';
  static const myDemands = '/demand/mine';
  static String demandOffers(String id) => '/demand/$id/offers';
  static const buyerDemands = '/demands';
  static String demandDetails(String id) => '/demands/$id';
  static const ratings = '/ratings';
  static const verifyAndRatings = '/ratings?verify=1';
  static String buyerTrack(String id) => '/buyer/track/$id';
  static String receipt(String orderId) => '/receipt/$orderId';

  static const farmerHome = '/farmer';
  static const buyerHome = '/buyer';
  static const transporterHome = '/transporter';
  static const moderatorHome = '/moderator';
  static const adminHome = '/admin';

  // Farmer
  static const farmerSell = '/farmer/sell';
  static const farmerListings = '/farmer/listings';
  static String farmerListingDetails(String id) => '/farmer/listings/$id';

  // Buyer
  // Shared by farmer (28/17) and buyer (74/73).
  static const buyerSearch = '/search';
  static String buyerListing(String id) => '/listing/$id';
  static String buyerFarmer(String uid) => '/people/farmer/$uid';
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
  static const trReturnLoads = '/transporter/loads?return=1';
  static String trLoad(String id) => '/transporter/load/$id';
  static String trFareOffer(String id) => '/transporter/load/$id/offer';
  static String trJob(String id) => '/transporter/job/$id';
  static String trTrip(String id) => '/transporter/trip/$id';
  static String trDeliver(String id) => '/transporter/trip/$id/deliver';
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
    (_) => Future<void>.delayed(const Duration(milliseconds: 1500)));

/// Re-runs go_router redirects whenever auth / profile / prefs change.
class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(Ref ref) {
    void ping(_, _) => notifyListeners();
    ref.listen(authStateProvider, ping);
    ref.listen(currentUserProvider, ping);
    ref.listen(localeProvider, ping);
    ref.listen(onboardingDoneProvider, ping);
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
    // 6. No role yet.
    if (!u.hasRole) return loc == Routes.role ? null : Routes.role;
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
          path: Routes.onboarding, builder: (_, _) => const OnboardingScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(path: Routes.otp, builder: (_, _) => const OtpScreen()),
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
      GoRoute(
          path: Routes.payments, builder: (_, _) => const PaymentsScreen()),
      GoRoute(
          path: Routes.postDemand,
          builder: (_, _) => const PostDemandScreen()),
      GoRoute(
          path: Routes.myDemands, builder: (_, _) => const MyDemandsScreen()),
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
          builder: (_, _) => const ProfileSetupScreen(editing: true)),
      GoRoute(
          path: Routes.verification,
          builder: (_, _) => const VerificationScreen()),
      GoRoute(
        path: Routes.ratings,
        builder: (_, s) => RatingsScreen(
            withVerification: s.uri.queryParameters['verify'] == '1'),
      ),
      GoRoute(
        path: '/receipt/:id',
        builder: (_, s) => ReceiptScreen(orderId: s.pathParameters['id']!),
      ),
      GoRoute(path: Routes.role, builder: (_, _) => const RoleScreen()),
      GoRoute(
          path: Routes.profileSetup,
          builder: (_, _) => const ProfileSetupScreen()),
      GoRoute(
          path: Routes.locationPicker,
          builder: (_, _) => const LocationPickerScreen()),
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
      GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
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
          GoRoute(
              path: 'queue', builder: (_, _) => const ListingsQueuePage()),
          GoRoute(
              path: 'reports',
              builder: (_, _) => const ReportsQueue(showBack: true)),
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
          GoRoute(
              path: 'crops', builder: (_, _) => const CropCatalogScreen()),
        ],
      ),
      GoRoute(
        path: Routes.buyerHome,
        builder: (_, _) => const BuyerShell(),
        routes: [
          GoRoute(
            path: 'pay',
            builder: (_, s) =>
                SafePaymentScreen(draft: s.extra! as OrderDraft),
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
              builder: (_, _) => const BuyerTransportScreen()),
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
            path: 'loads',
            builder: (_, s) => LoadsScreen(
                returnOnly: s.uri.queryParameters['return'] == '1'),
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
                path: 'deliver',
                builder: (_, s) =>
                    ProofOfDeliveryScreen(deliveryId: s.pathParameters['id']!),
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
