import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UseCaseMaintainsFirebase {
  final FirebaseFirestore firestore;

  UseCaseMaintainsFirebase({required this.firestore});

  // Method to check if maintenance mode is active and get end time
  Future<Map<String, dynamic>> getMaintenanceStatus() async {
    try {
      print("Fetching maintenance status from Firestore...");
      final DocumentSnapshot snapshot = await firestore.collection('app_status').doc('maintenance').get();

      // Extracting the is_active and end_time fields with null-safety checks
      bool isActive = snapshot['is_active'] ?? false;
      Timestamp? endTime = snapshot['end_time']; // Assumes 'end_time' is a Firestore Timestamp

      print("Fetched data: is_active = $isActive, end_time = $endTime");

      String formattedEndTime = '';
      if (endTime != null) {
        formattedEndTime = _formatTimestamp(endTime);
        print("Formatted end time: $formattedEndTime");
      }

      // Return both maintenance status and formatted end time
      return {
        'is_active': isActive,
        'end_time': formattedEndTime,
      };
    } catch (e) {
      print("Error fetching maintenance status: $e");
      return {
        'is_active': false,
        'end_time': '',
      };
    }
  }

  // Private method to format Firestore Timestamp into human-readable date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // Format as "YYYY-MM-DD HH:mm:ss"
    print("Timestamp $timestamp formatted as $formattedDate");
    return formattedDate;
  }
}
