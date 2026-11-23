import 'package:flutter_localizations/flutter_localizations.dart'
    show GlobalWidgetsLocalizations;
import 'package:cupertino_ui/cupertino_ui.dart' show GlobalCupertinoLocalizations;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../core/l10n/locale_controller.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/data/user_repository.dart';
import '../features/call/presentation/incoming_call_listener.dart';
import '../features/trade/presentation/notification_popups.dart';
import '../features/transport/data/live_location.dart';
import '../shared/data/trade_stats_repository.dart';
import '../l10n/app_localizations.dart';
import 'router.dart';

class KrishiSyncApp extends ConsumerWidget {
  const KrishiSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    // Driver's phone sends the truck position while a trip is active.
    ref.watch(liveTrackerProvider);
    // Farmer / driver: adds finished deals to their public track record.
    ref.watch(tradeStatsSyncProvider);

    // If someone is signed in but has no users/{uid} yet (e.g. the app was
    // closed right after OTP), create it.
    ref.listen(currentUserProvider, (_, next) {
      final fb = ref.read(authStateProvider).value;
      if (fb != null && next.hasValue && next.value == null) {
        ref.read(userRepositoryProvider).ensureUserDoc(
              uid: fb.uid,
              phone: fb.phoneNumber ?? '',
              language: locale?.languageCode ?? 'bn',
            );
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (c) => AppLocalizations.of(c).appName,
      theme: AppTheme.light,
      routerConfig: router,
      // Phone popups for new notifications (local; FCM after Blaze).
      // Incoming in-app calls open their screen from anywhere.
      builder: (_, child) => NotificationPopups(
        child: IncomingCallListener(child: child ?? const SizedBox.shrink()),
      ),
      // Before the user picks (screen 02) we show Bangla, as in Figma.
      locale: locale ?? const Locale('bn'),
      supportedLocales: supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
