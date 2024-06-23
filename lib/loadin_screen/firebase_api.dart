// import 'dart:convert';
// import 'package:awesome_notifications/awesome_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:http/http.dart' as http;

// class FirebaseApi {
//   static Future<void> initializeFirebase() async {
//     await Firebase.initializeApp();
//   }

//   static FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   static Future<String?> getFirebaseToken() async {
//     String? token;
//     try {
//       token = await _firebaseMessaging.getToken();
//       print("Firebase Token: $token");
//     } catch (e) {
//       print("Error getting Firebase token: $e");
//     }
//     return token;
//   }

//   static void configureFirebaseMessaging() {
//     _firebaseMessaging
//         .getInitialMessage()
//         .then((RemoteMessage? message) {
//       if (message != null) {
//         print("onLaunch: $message");
//         _handleNotification(message.data);
//       }
//     });

//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: $message");
//       _handleNotification(message.data);
//     });

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onResume: $message");
//       _handleNotification(message.data);
//     });
//   }

//   Future<void> sendNotificationToTopic(String title, String body) async {
//     final String serverKey = 'AAAAFU8_Lfg:APA91bFNC15ku_xQ3qmnafeFMfYeP9iW7gFBaX2HVLqk3iTnjUTmNU1Nc75SGNcgXFUdh1mE3rCJDFf-9puxovNDshn_M4g5GybUKsxeZJYB35m5vOqP3GeL1Oz1F_XkkYH6hiqk0WoC'; // Replace with your FCM server key
//     final String url = 'https://fcm.googleapis.com/fcm/send';

//     final Map<String, dynamic> payload = {
//       'notification': {
//         'title': title,
//         'body': body,
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//         'android': {
//           'notification': {
//             'icon': 'ic_launcher', // Replace with the name of your icon resource
//           },
//         },
//       },
//       'to': '/topics/all',
//     };

//     final http.Response response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json',
//         'Authorization': 'key=$serverKey',
//       },
//       body: jsonEncode(payload),
//     );

//     if (response.statusCode == 200) {
//       print('Notification sent successfully');
//     } else {
//       print('Failed to send notification. Status code: ${response.statusCode}');
//     }
//   }

//   static void _handleNotification(Map<String, dynamic> message) {
//     // Handle the notification payload as needed
//     // You can use this method to navigate to a specific screen or perform other actions when a notification is received
//   }
// }