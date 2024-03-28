import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future<void> createNotifications(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'pushnotifications',
          'pushnotificationschannel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      );
      await _notificationsPlugin.show(
        id,
        message.notification!.title ?? '',
        message.notification!.body ?? '',
        notificationDetails,
      );
    } catch (e) {
      print(e);
    }
  }

  static void showNotification({required String title, required String body}) {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
    _notificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
