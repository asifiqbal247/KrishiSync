import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/local_notification_service.dart';
import '../../auth/data/user_repository.dart';
import '../data/trade_repository.dart';
import '../domain/trade_models.dart';
import 'notifications_screen.dart';

/// Shows a phone popup for every new item in the bell list (16 / 72 / 142)
/// while the app is open or in the background. Old items never pop up.
class NotificationPopups extends ConsumerStatefulWidget {
  const NotificationPopups({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<NotificationPopups> createState() => _NotificationPopupsState();
}

class _NotificationPopupsState extends ConsumerState<NotificationPopups> {
  /// Server vs phone clock difference allowed when judging "new".
  static const _clockSlack = Duration(minutes: 2);

  final _service = LocalNotificationService.instance;
  String? _uid;
  Set<String>? _seen;
  DateTime _since = DateTime.now();

  @override
  void initState() {
    super.initState();
    _service.onOpen = _open;
    _service.init();
  }

  /// Payload `n:{id}:{route}` = a bell item (mark read, then open it);
  /// anything else is a plain route (e.g. an incoming call).
  void _open(String payload) {
    final router = ref.read(routerProvider);
    if (!payload.startsWith(_prefix)) {
      router.push(payload);
      return;
    }
    final rest = payload.substring(_prefix.length);
    final i = rest.indexOf(':');
    final id = rest.substring(0, i);
    final route = rest.substring(i + 1);
    final uid = ref.read(currentUserProvider).value?.uid;
    if (uid != null) {
      ref.read(tradeRepositoryProvider).markRead(uid, id).catchError((_) {});
    }
    router.push(route.isEmpty ? Routes.notifications : route);
  }

  static const _prefix = 'n:';

  void _onList(List<AppNotification> list) {
    final uid = ref.read(currentUserProvider).value?.uid;
    if (uid == null) return;
    // New sign-in: what is already there is not new.
    if (uid != _uid || _seen == null) {
      _uid = uid;
      _seen = {for (final n in list) n.id};
      _since = DateTime.now().subtract(_clockSlack);
      return;
    }
    for (final n in list.reversed) {
      if (!_seen!.add(n.id) || n.read) continue;
      // A late server snapshot can bring older items: skip those.
      final at = n.createdAt;
      if (at != null && at.isBefore(_since)) continue;
      _popup(n);
    }
  }

  void _popup(AppNotification n) {
    final l = AppLocalizations.of(context);
    final (title, body) = NotificationsScreen.text(context, n);
    _service.show(
      id: n.id.hashCode,
      title: title,
      body: body,
      channelName: l.notifChannelName,
      route: '$_prefix${n.id}:${NotificationsScreen.routeFor(n) ?? ''}',
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(myNotificationsProvider, (_, next) {
      final list = next.value;
      if (list != null) _onList(list);
    });
    return widget.child;
  }
}
