import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifservice {
  final notifPlugin = FlutterLocalNotificationsPlugin();

  bool _init = false;

  bool get isInitialized => _init;

  Future initNotifs() async {
    if (_init) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );

    const initSettings = InitializationSettings(android: initSettingsAndroid);

    final result = await notifPlugin.initialize(initSettings);
    if (result != null) _init = result;
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "42chatapp",
        "42 ChatApp",
        channelDescription: "42 ChatApp Channel",
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future showNotification() async {
    return notifPlugin.show(
      0,
      "42 ChatApp",
      "You have a new message.",
      notificationDetails(),
    );
  }
}
