import 'package:cloud_firestore/cloud_firestore.dart';

class UseCaseMaintainsFirebase {
  final FirebaseFirestore firestore;

  UseCaseMaintainsFirebase({required this.firestore});

  Future<bool> checkForMaintenanceMode() async {
    try {
      // Fetch maintenance status from Firestore
      DocumentSnapshot snapshot = await firestore.collection('app_status').doc('maintenance').get();
      bool isInMaintenance = snapshot.get('is_active') ?? false;
      return isInMaintenance;
    } catch (e) {
      print("Error checking maintenance mode: $e");
      return false; // Return false if there's an error
    }
  }
}
