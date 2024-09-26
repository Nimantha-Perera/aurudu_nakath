import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Make the method public by removing the underscore
Future<void> saveUserDetails(bool subscribed, Timestamp subscribeTime) async {
    // Step 1: Retrieve user details from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? displayName = prefs.getString('displayName');

    // Check if email and displayName are not null
    if (email == null || displayName == null) {
      print("User details not found in SharedPreferences.");
      return; // Handle the case where user details are not available
    }

    // Step 2: Check if the user document exists in Firestore
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('helagptpro_users').doc(email).get();

      if (docSnapshot.exists) {
        // Document exists, update only the 'subscribed' boolean
        await _firestore.collection('helagptpro_users').doc(email).update({
          'subscribed': subscribed,
        });
        print("User subscription status updated in Firestore.");
      } else {
        // Document does not exist, create a new document
        await _firestore.collection('helagptpro_users').doc(email).set({
          'email': email,
          'displayName': displayName,
          'subscribed': subscribed,
          'subscribe_time': subscribeTime,
        });
        print("User details saved to Firestore.");
      }
    } catch (e) {
      print("Error saving user to Firestore: $e");
      // Handle error (e.g., show a message to the user)
    }
  }

  Future<void> updateSubscriptionStatus(bool subscribed) async {
    // Step 1: Retrieve user details from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email'); // Retrieve email instead of displayName

    if (email == null) {
      print("User email not found in SharedPreferences.");
      return; // Handle the case where user email is not available
    }

    // Step 2: Check if the user document exists in Firestore
    try {
      DocumentSnapshot docSnapshot = await _firestore
          .collection('helagptpro_users')
          .doc(email)
          .get();

      if (docSnapshot.exists) {
        // Document exists, update the 'subscribed' field
        await _firestore.collection('helagptpro_users').doc(email).update({
          'subscribed': subscribed,
        });
        print("User subscription status updated in Firestore.");
      } else {
        // Document does not exist
        print("No document found for email: $email. Cannot update subscription status.");
      }
    } catch (e) {
      print("Error updating user subscription status: $e");
      // Handle error (e.g., show a message to the user)
    }
  }
}
