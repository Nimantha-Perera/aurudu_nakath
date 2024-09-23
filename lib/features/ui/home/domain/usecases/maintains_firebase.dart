import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // For formatting date and time

class UseCaseMaintainsFirebase {
  final FirebaseFirestore firestore;

  UseCaseMaintainsFirebase({required this.firestore});

  // Method to check if maintenance mode is active and get end time
  Future<Map<String, dynamic>> getMaintenanceStatus() async {
    final DocumentSnapshot snapshot = await firestore.collection('app_status').doc('maintenance').get();
    
    // Extracting the is_active and end_time fields
    bool isActive = snapshot['is_active'] ?? false;
    Timestamp? endTime = snapshot['end_time']; // Assumes 'end_time' is a Firestore Timestamp
    
    String formattedEndTime = '';
    if (endTime != null) {
      formattedEndTime = _formatTimestamp(endTime);
    }

    // Return both maintenance status and formatted end time
    return {
      'is_active': isActive,
      'end_time': formattedEndTime,
    };
  }

  // Private method to format Firestore Timestamp into human-readable date and time
  String _formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // Format as "YYYY-MM-DD HH:mm:ss"
  }
}
