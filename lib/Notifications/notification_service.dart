import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
  print("Notification payload: ${response.payload}");
}

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize Firebase
    await Firebase.initializeApp();

    // Request permissions
    await _requestPermissions();

    // Initialize local notifications
    _initializeLocalNotifications();

    // Initialize Firebase Messaging
    _firebaseInit();
    // getFcmToken();
  }

  Future<void> _requestPermissions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check stored notification permission status
    bool storedPermission = prefs.getBool('notificationPermission') ?? false;

    // Request multiple permissions using permission_handler
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
      Permission.manageExternalStorage, // For Android 10+ storage access
      Permission.scheduleExactAlarm,    // For scheduling alarms in Android 12+
    ].request();

    bool grantedNotificationPermission =
        statuses[Permission.notification]?.isGranted ?? false;

    // If stored permission does not match the current permission, update it
    if (storedPermission != grantedNotificationPermission) {
      await _savePermissionStatus(grantedNotificationPermission);
    }

    // Handle individual permissions
    if (statuses[Permission.manageExternalStorage]?.isGranted ?? false) {
      print("Manage External Storage permission granted.");
    } else {
      print("Manage External Storage permission not granted.");
    }

    if (statuses[Permission.scheduleExactAlarm]?.isGranted ?? false) {
      print("Schedule Exact Alarm permission granted.");
    } else {
      print("Schedule Exact Alarm permission not granted.");
    }

    // Additionally, check Firebase Messaging permission status
    await _requestFirebaseMessagingPermission();
  }

  Future<void> _requestFirebaseMessagingPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    bool granted =
        settings.authorizationStatus == AuthorizationStatus.authorized;

    if (!granted) {
      print("Firebase Messaging permission not granted.");
    } else {
      print("Firebase Messaging permission granted.");
    }
  }

  Future<void> _savePermissionStatus(bool granted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationPermission', granted);
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );

    _createNotificationChannel();
  }

  void _createNotificationChannel() {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'important_messages', // id
      'Nakath Notifications', // name
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  void _firebaseInit() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'important_messages', // Use the specific channel
              'Nakath Notifications',
              channelDescription:
                  'This channel is used for important notifications.',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Future<String?> getFcmToken() async {
  //   return await _messaging.getToken();
  // }

  // void onTokenRefresh() {
  //   _messaging.onTokenRefresh.listen((newToken) {
  //     print("Refreshed Token: $newToken");
  //   });
  // }
}
