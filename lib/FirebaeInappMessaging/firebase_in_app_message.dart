import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

class FirebaseInAppMessage {
  final FirebaseInAppMessaging _fiam = FirebaseInAppMessaging.instance;

  Future<void> showInAppMessage() async {
    try {
      // Here you can implement the logic for fetching or preparing the in-app message
      // For demonstration, we trigger an event that may show an in-app message
      await _fiam.triggerEvent("show_message_event");
    } catch (e) {
      print("Error showing in-app message: $e");
      // Handle errors or logging
    }
  }

  Future<void> dismissInAppMessage() async {
    try {
      // Dismiss any displayed in-app messages (if applicable)
      // Note: Firebase In-App Messaging handles the dismissal automatically,
      // but you can implement your logic if required.
      print("In-App message dismissed.");
      // You could also send analytics or log dismissals to a backend or local storage.
    } catch (e) {
      print("Error dismissing in-app message: $e");
      // Handle errors or logging
    }
  }
}
