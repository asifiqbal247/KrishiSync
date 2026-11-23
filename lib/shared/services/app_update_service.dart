import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/user_repository.dart';

/// Firestore appConfig/android — set by Asif in the Firebase console for
/// every release (see docs/RELEASE.md).
class AppUpdateInfo {
  const AppUpdateInfo({
    required this.latestCode,
    required this.latestName,
    required this.minCode,
    required this.apkUrl,
    required this.changelogBn,
    required this.changelogEn,
  });

  /// Build number after "+" in pubspec (1.0.2+3 → 3).
  final int latestCode;
  final String latestName;

  /// Older than this must update (no "পরে" button).
  final int minCode;
  final String apkUrl;
  final String changelogBn;
  final String changelogEn;

  factory AppUpdateInfo.fromMap(Map<String, dynamic> m) => AppUpdateInfo(
    latestCode: (m['latestVersionCode'] as num?)?.toInt() ?? 0,
    latestName: m['latestVersionName'] as String? ?? '',
    minCode: (m['minVersionCode'] as num?)?.toInt() ?? 0,
    apkUrl: m['apkUrl'] as String? ?? '',
    changelogBn: m['changelogBn'] as String? ?? '',
    changelogEn: m['changelogEn'] as String? ?? '',
  );
}

/// An update this phone should get, and whether it is required.
class AvailableUpdate {
  const AvailableUpdate(this.info, {required this.force});
  final AppUpdateInfo info;
  final bool force;
}

class AppUpdateService {
  AppUpdateService(this._db);
  final FirebaseFirestore _db;

  static const _channel = MethodChannel('golaghor/app_info');

  /// Split-per-ABI APKs get 1000 × ABI added to the version code
  /// (arm64: 2003 for build 3), so only the last three digits count.
  static const _abiStep = 1000;

  /// The installed build number (pubspec "+N"), or null if unknown.
  Future<int?> installedBuild() async {
    final m = await _channel.invokeMapMethod<String, dynamic>('version');
    final code = (m?['code'] as num?)?.toInt();
    return code == null ? null : code % _abiStep;
  }

  Future<AvailableUpdate?> check() async {
    final installed = await installedBuild();
    if (installed == null) return null;
    final doc = await _db.collection('appConfig').doc('android').get();
    final m = doc.data();
    if (m == null) return null;
    final info = AppUpdateInfo.fromMap(m);
    if (info.apkUrl.isEmpty || installed >= info.latestCode) return null;
    return AvailableUpdate(info, force: installed < info.minCode);
  }
}

final appUpdateServiceProvider = Provider(
  (ref) => AppUpdateService(ref.watch(firestoreProvider)),
);
