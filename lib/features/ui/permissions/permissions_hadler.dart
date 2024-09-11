import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  bool _isRequesting = false; // Track whether a request is in progress

  // Request specific permissions
  Future<void> requestPermissions() async {
    if (_isRequesting) {
      print("A permission request is already in progress.");
      return;
    }

    _isRequesting = true; // Set flag to indicate a request is in progress

    try {
      // Requesting multiple permissions at once
      Map<Permission, PermissionStatus> statuses = await [
        Permission.notification,
        Permission.manageExternalStorage, // For Android 10+
        Permission.scheduleExactAlarm,  // For exact alarms in Android 12+
      ].request();

      // Check each permission status and handle accordingly
      if (statuses[Permission.notification]?.isGranted ?? false) {
        print("Notification permission granted.");
      } else {
        print("Notification permission not granted.");
      }

      if (statuses[Permission.manageExternalStorage]?.isGranted ?? false) {
        print("Manage External Storage permission granted.");
      } else {
        print("Manage External Storage permission not granted.");
      }

      if (statuses[Permission.scheduleExactAlarm]?.isGranted ?? false) {
        print("Scheduled Exact Alarm permission granted.");
      } else {
        print("Scheduled Exact Alarm permission not granted.");
      }
    } catch (e) {
      print("Error requesting permissions: $e");
    } finally {
      _isRequesting = false; // Reset the flag after the request completes
    }
  }
}
