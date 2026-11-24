import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../features/auth/data/user_repository.dart';

/// presence/{uid} = {at}: the last time this person's app was open.
/// Kept apart from users/{uid} so the heartbeat doesn't refresh every
/// screen that shows the profile.
class PresenceRepository {
  PresenceRepository(this._db);
  final FirebaseFirestore _db;

  /// "এখন সক্রিয়" while the last heartbeat is newer than this.
  static const activeWindow = Duration(minutes: 2);

  /// How often an open app says "still here".
  static const beat = Duration(minutes: 1);

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _db.collection('presence').doc(uid);

  Future<void> ping(String uid) =>
      _doc(uid).set({'at': FieldValue.serverTimestamp()});

  Stream<DateTime?> watch(String uid) =>
      _doc(uid)
          .snapshots()
          .map((d) => (d.data()?['at'] as Timestamp?)?.toDate());

  static bool isActive(DateTime? at) =>
      at != null && DateTime.now().difference(at) < activeWindow;
}

final presenceRepositoryProvider = Provider(
  (ref) => PresenceRepository(ref.watch(firestoreProvider)),
);

final presenceProvider = StreamProvider.family<DateTime?, String>(
  (ref, uid) => ref.watch(presenceRepositoryProvider).watch(uid),
);

/// Sends the heartbeat once a minute while the app is in front (and once
/// on opening), so others see "এখন সক্রিয়".
class PresenceHeartbeat extends ConsumerStatefulWidget {
  const PresenceHeartbeat({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<PresenceHeartbeat> createState() => _PresenceHeartbeatState();
}

class _PresenceHeartbeatState extends ConsumerState<PresenceHeartbeat>
    with WidgetsBindingObserver {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _start();
    } else if (state == AppLifecycleState.paused) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _start() {
    _ping();
    _timer?.cancel();
    _timer = Timer.periodic(PresenceRepository.beat, (_) => _ping());
  }

  void _ping() {
    final uid = ref.read(currentUserProvider).value?.uid;
    if (uid == null) return;
    ref.read(presenceRepositoryProvider).ping(uid).catchError((_) {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Signed in after the app opened: send the first beat right away.
    ref.listen(currentUserProvider.select((u) => u.value?.uid), (prev, next) {
      if (next != null && prev != next) _ping();
    });
    return widget.child;
  }
}
