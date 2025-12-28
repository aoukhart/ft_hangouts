import 'package:another_telephony/telephony.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ft_hangouts/Datasource/DataHelper.dart';

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

  Future showNotification(SmsMessage msg) async {
    // await DataHelper.getUsers().then((value) {
    // if (value == null) return;
    // value.forEach((e) {
    // User.fromMap(e).phone == msg.address
    // ?
    final db = await DataHelper.db;
    final users = await db.query(
      'users',
      columns: ['id', 'name', 'phone', 'bio', 'time', 'image'],
      orderBy: 'time DESC',
    );
    if (users.isEmpty) return;
    print("<<<<<<<< got users >>>>>>>>");
    for (var user in users) {
      print(user['phone']);
      if (user['phone'] == msg.address) {
        notifPlugin.show(
          0,
          "42 ChatApp",
          "You have a new message.",
          notificationDetails(),
        );
      }
    }
    // : null;
    // });
    // });
  }
}
