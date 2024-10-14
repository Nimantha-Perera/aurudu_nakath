import 'package:aurudu_nakath/features/ui/maintance/maintance_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UseCaseMaintainsFirebase {
  final FirebaseFirestore firestore;

  UseCaseMaintainsFirebase({required this.firestore});

  // Method to check if maintenance mode is active and get end time
  Future<Map<String, dynamic>> getMaintenanceStatus() async {
    try {
      final DocumentSnapshot snapshot = await firestore.collection('app_status').doc('maintenance').get();

      // Extracting the is_active and end_time fields with null-safety checks
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
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime); // Format as "YYYY-MM-DD HH:mm:ss"
  }

  // Public method to check maintenance mode and display MaintenanceScreenDialog
  Future<void> checkForMaintenanceMode(BuildContext context) async {
    Map<String, dynamic> maintenanceStatus = await getMaintenanceStatus();
    if (maintenanceStatus['is_active'] == true) {
      // Show the full-screen maintenance dialog if maintenance is active
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MaintenanceScreenDialog(
            endTime: maintenanceStatus['end_time'], // Pass the formatted end time
          ),
        ),
      );
    } else {
      // Maintenance is not active
      print("App is not in maintenance mode");
    }
  }
}
