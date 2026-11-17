import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in main() with the loaded instance.
final sharedPrefsProvider = Provider<SharedPreferences>(
  (_) => throw UnimplementedError('sharedPrefsProvider not overridden'),
);

const supportedLocales = [Locale('bn'), Locale('en')];

/// App language. `null` = user has not chosen yet (show screen 02).
class LocaleController extends Notifier<Locale?> {
  static const _key = 'app_language';

  @override
  Locale? build() {
    final code = ref.watch(sharedPrefsProvider).getString(_key);
    return code == null ? null : Locale(code);
  }

  Future<void> set(Locale locale) async {
    await ref.read(sharedPrefsProvider).setString(_key, locale.languageCode);
    state = locale;
  }

  /// Forget the choice so screen 02 shows again.
  Future<void> reset() async {
    await ref.read(sharedPrefsProvider).remove(_key);
    state = null;
  }
}

final localeProvider = NotifierProvider<LocaleController, Locale?>(
  LocaleController.new,
);

/// Onboarding seen flag (03–05 are shown once).
class OnboardingController extends Notifier<bool> {
  static const _key = 'onboarding_done';

  @override
  bool build() => ref.watch(sharedPrefsProvider).getBool(_key) ?? false;

  Future<void> complete() async {
    await ref.read(sharedPrefsProvider).setBool(_key, true);
    state = true;
  }

  /// Show onboarding again (back from Login).
  Future<void> reset() async {
    await ref.read(sharedPrefsProvider).remove(_key);
    state = false;
  }
}

final onboardingDoneProvider = NotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);
