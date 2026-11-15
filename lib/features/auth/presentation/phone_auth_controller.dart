import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/formatters.dart';
import '../../../core/l10n/locale_controller.dart';
import '../data/auth_repository.dart';
import '../data/user_repository.dart';

/// Bangladesh mobile: 11 digits, 013–019 prefix.
abstract final class BdPhone {
  static final _re = RegExp(r'^01[3-9]\d{8}$');

  /// Accepts "01712345678", "+8801712345678", Bangla digits, spaces, dashes.
  static String? normalizeLocal(String input) {
    var s = Fmt.latinDigits(input).replaceAll(RegExp(r'[\s-]'), '');
    if (s.startsWith('+880')) s = '0${s.substring(4)}';
    if (s.startsWith('880')) s = '0${s.substring(3)}';
    return _re.hasMatch(s) ? s : null;
  }

  static String toE164(String local) => '+88$local';

  /// 01712345678 → 01712-345678 (Figma OTP subtitle format).
  static String pretty(String local) =>
      '${local.substring(0, 5)}-${local.substring(5)}';
}

class PhoneAuthState {
  const PhoneAuthState({
    this.localPhone,
    this.verificationId,
    this.resendToken,
    this.sending = false,
    this.verifying = false,
    this.error,
  });

  final String? localPhone;
  final String? verificationId;
  final int? resendToken;
  final bool sending;
  final bool verifying;
  final AuthErrorCode? error;

  PhoneAuthState copyWith({
    String? localPhone,
    String? verificationId,
    int? resendToken,
    bool? sending,
    bool? verifying,
    AuthErrorCode? error,
    bool clearError = false,
  }) => PhoneAuthState(
    localPhone: localPhone ?? this.localPhone,
    verificationId: verificationId ?? this.verificationId,
    resendToken: resendToken ?? this.resendToken,
    sending: sending ?? this.sending,
    verifying: verifying ?? this.verifying,
    error: clearError ? null : (error ?? this.error),
  );
}

class PhoneAuthController extends Notifier<PhoneAuthState> {
  static const _verifyTimeout = Duration(seconds: 30);

  @override
  PhoneAuthState build() => const PhoneAuthState();

  AuthRepository get _auth => ref.read(authRepositoryProvider);

  /// Returns true when the code was sent (go to OTP screen).
  /// Auto-verification on Android signs in directly; router then moves on.
  Future<bool> sendCode(String localPhone, {bool resend = false}) async {
    state = state.copyWith(
      localPhone: localPhone,
      sending: true,
      clearError: true,
    );
    try {
      final r = await _auth.sendCode(
        BdPhone.toE164(localPhone),
        resendToken: resend ? state.resendToken : null,
      );
      switch (r) {
        case CodeSent(:final verificationId, :final resendToken):
          state = state.copyWith(
            verificationId: verificationId,
            resendToken: resendToken,
            sending: false,
          );
          return true;
        case AutoVerified(:final user):
          await _afterSignIn(user.uid, user.phoneNumber ?? '');
          state = state.copyWith(sending: false);
          return false;
      }
    } on AuthFailure catch (e) {
      state = state.copyWith(sending: false, error: e.code);
      return false;
    } catch (_) {
      state = state.copyWith(sending: false, error: AuthErrorCode.unknown);
      return false;
    }
  }

  Future<void> verify(String code) async {
    final id = state.verificationId;
    if (id == null) return;
    state = state.copyWith(verifying: true, clearError: true);
    try {
      // Don't spin forever on a weak connection (shows "no internet").
      final user = await _auth
          .verifyCode(id, Fmt.latinDigits(code))
          .timeout(_verifyTimeout);
      await _afterSignIn(
        user.uid,
        user.phoneNumber ?? '',
      ).timeout(_verifyTimeout);
      state = state.copyWith(verifying: false);
    } on TimeoutException {
      state = state.copyWith(verifying: false, error: AuthErrorCode.network);
    } on AuthFailure catch (e) {
      state = state.copyWith(verifying: false, error: e.code);
    } catch (_) {
      state = state.copyWith(verifying: false, error: AuthErrorCode.unknown);
    }
  }

  Future<void> _afterSignIn(String uid, String phone) => ref
      .read(userRepositoryProvider)
      .ensureUserDoc(
        uid: uid,
        phone: phone,
        language: ref.read(localeProvider)?.languageCode ?? 'bn',
      );
}

final phoneAuthProvider = NotifierProvider<PhoneAuthController, PhoneAuthState>(
  PhoneAuthController.new,
);
