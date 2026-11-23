import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Popup (system tray) notifications shown by the app itself while it is
/// open or in the background. On the Spark plan there is no server push;
/// when the project moves to Blaze, FCM can feed the same [show].
class LocalNotificationService {
  LocalNotificationService._();
  static final instance = LocalNotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  static const _channelId = 'golaghor_alerts';
  static const _icon = '@mipmap/ic_launcher';
  Future<void>? _init;

  /// Called with the app route when the user taps a popup.
  void Function(String route)? onOpen;

  Future<void> init() => _init ??= _plugin
      .initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings(_icon),
        ),
        onDidReceiveNotificationResponse: (r) {
          final route = r.payload;
          if (route != null && route.isNotEmpty) onOpen?.call(route);
        },
      )
      .then((_) {});

  Future<void> show({
    required int id,
    required String title,
    required String body,
    required String channelName,
    String? route,
  }) async {
    await init();
    await _plugin.show(
      id: id,
      title: title,
      body: body.isEmpty ? null : body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      payload: route,
    );
  }
}
