import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/router.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/services/local_notification_service.dart';
import '../data/call_repository.dart';

/// Opens the incoming call screen (and a phone popup, for when the app is
/// in the background) when someone calls. Works while the app is open or
/// minimised; FCM can wake a closed app after the Blaze upgrade.
class IncomingCallListener extends ConsumerStatefulWidget {
  const IncomingCallListener({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<IncomingCallListener> createState() => _State();
}

class _State extends ConsumerState<IncomingCallListener> {
  /// Server vs phone clock difference allowed when judging "still ringing".
  static const _clockSlack = Duration(minutes: 1);

  final _shown = <String>{};
  final _service = LocalNotificationService.instance;

  void _onCalls(List<Call> calls) {
    final ringing = {for (final c in calls) c.id};
    // Stopped ringing (answered elsewhere, cancelled, missed): drop popup.
    for (final id in _shown.where((id) => !ringing.contains(id)).toList()) {
      _service.cancel(id.hashCode);
      _shown.remove(id);
    }
    final oldest = DateTime.now().subtract(
      CallRepository.ringTimeout + _clockSlack,
    );
    for (final c in calls) {
      if (_shown.contains(c.id)) continue;
      final at = c.createdAt;
      if (at != null && at.isBefore(oldest)) continue; // stale
      _shown.add(c.id);
      final l = AppLocalizations.of(context);
      final route = Routes.incomingCall(c.id);
      _service.show(
        id: c.id.hashCode,
        title: c.callerName,
        body: c.video ? l.callIncomingVideo : l.callIncoming,
        channelName: l.notifChannelName,
        route: route,
      );
      ref.read(routerProvider).push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(incomingCallsProvider, (_, next) {
      final calls = next.value;
      if (calls != null) _onCalls(calls);
    });
    return widget.child;
  }
}
