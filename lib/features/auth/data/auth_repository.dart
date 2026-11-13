import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error codes the UI maps to localized text.
enum AuthErrorCode { invalidPhone, invalidCode, tooManyRequests, network, unknown }

class AuthFailure implements Exception {
  AuthFailure(this.code, [this.detail]);
  final AuthErrorCode code;
  final String? detail;
  @override
  String toString() => 'AuthFailure($code, $detail)';
}

/// Outcome of asking Firebase to send a code.
sealed class CodeSendResult {}

class CodeSent extends CodeSendResult {
  CodeSent(this.verificationId, this.resendToken);
  final String verificationId;
  final int? resendToken;
}

/// Android sometimes verifies automatically (no code typing needed).
class AutoVerified extends CodeSendResult {
  AutoVerified(this.user);
  final User user;
}

abstract interface class AuthRepository {
  Stream<User?> authStateChanges();
  User? get currentUser;

  /// [phoneE164] like +8801712345678.
  Future<CodeSendResult> sendCode(String phoneE164, {int? resendToken});
  Future<User> verifyCode(String verificationId, String smsCode);
  Future<void> signOut();
}

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);
  final FirebaseAuth _auth;

  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  @override
  Future<CodeSendResult> sendCode(String phoneE164, {int? resendToken}) {
    final c = Completer<CodeSendResult>();
    _auth.verifyPhoneNumber(
      phoneNumber: phoneE164,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (cred) async {
        if (c.isCompleted) return;
        try {
          final r = await _auth.signInWithCredential(cred);
          c.complete(AutoVerified(r.user!));
        } on FirebaseAuthException catch (e) {
          if (!c.isCompleted) c.completeError(_map(e));
        }
      },
      verificationFailed: (e) {
        if (!c.isCompleted) c.completeError(_map(e));
      },
      codeSent: (id, token) {
        if (!c.isCompleted) c.complete(CodeSent(id, token));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    return c.future;
  }

  @override
  Future<User> verifyCode(String verificationId, String smsCode) async {
    try {
      final cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);
      final r = await _auth.signInWithCredential(cred);
      return r.user!;
    } on FirebaseAuthException catch (e) {
      throw _map(e);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();

  AuthFailure _map(FirebaseAuthException e) => switch (e.code) {
        'invalid-phone-number' => AuthFailure(AuthErrorCode.invalidPhone, e.code),
        'invalid-verification-code' ||
        'invalid-verification-id' ||
        'session-expired' =>
          AuthFailure(AuthErrorCode.invalidCode, e.code),
        'too-many-requests' || 'quota-exceeded' =>
          AuthFailure(AuthErrorCode.tooManyRequests, e.code),
        'network-request-failed' => AuthFailure(AuthErrorCode.network, e.code),
        _ => AuthFailure(AuthErrorCode.unknown, '${e.code}: ${e.message}'),
      };
}

final firebaseAuthProvider = Provider<FirebaseAuth>((_) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>(
    (ref) => FirebaseAuthRepository(ref.watch(firebaseAuthProvider)));

final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(authRepositoryProvider).authStateChanges());
