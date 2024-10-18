import 'package:aurudu_nakath/features/ui/Login2/data/modal/user_model.dart';
import 'package:aurudu_nakath/features/ui/Login2/domain/usecase/sign_in_with_google.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel2 extends ChangeNotifier {
  final SignInWithGoogle2 _signInWithGoogle;
  CustomUser2? _user;
  bool _isLoading = false; // To manage loading state

  LoginViewModel2(this._signInWithGoogle);

  CustomUser2? get user => _user;
  bool get isLoading => _isLoading;

  /// Saves user details in SharedPreferences
  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _user!.email);
    await prefs.setString('displayName', _user!.displayName);
    await prefs.setString('photoURL', _user!.photoURL ?? '');
    await prefs.setString('userId', _user!.id?? '');
  }

  /// Logs in the user using Google Sign-In
  Future<void> login() async {
    _isLoading = true; // Set loading state to true
    notifyListeners();

    try {
      User? firebaseUser = await _signInWithGoogle.signIn();
      if (firebaseUser != null) {
        // Fetch user details from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          // Cast userDoc.data() to Map<String, dynamic>
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

          // Check if 'displayName' field exists in Firestore data
          String displayName = userData?['displayName'] ?? firebaseUser.displayName ?? '';

          _user = CustomUser2(
            email: firebaseUser.email!,
            displayName: displayName, // Use Firestore or FirebaseAuth displayName
            photoURL: firebaseUser.photoURL,
            id: firebaseUser.uid,
          );

          // Save user details in SharedPreferences
          await _saveUserDetails();
        } else {
          print("Document does not exist in Firestore for the user.");
        }
      }
    } catch (e) {
      print("Login failed: $e");
      // Handle specific error cases if needed (e.g., cancellation)
      if (e is FirebaseAuthException) {
        // Handle Firebase-specific errors if required
      }
      _user = null; // Reset user on failure
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  /// Checks the login status of the user and returns a bool indicating if logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId'); // Check for userId instead of email
    return userId != null; // Return true if the userId exists
  }

  /// Logs out the user and clears their information
  Future<void> logout(BuildContext context) async {
    await _signInWithGoogle.signOut();
    _user = null; // Clear user info

    // Get SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove only the user-related keys
    await prefs.remove('email');
    await prefs.remove('displayName');
    await prefs.remove('photoURL');
    await prefs.remove('userId');

    notifyListeners(); // Notify listeners to update the UI

    // Navigate to a different route
    Navigator.pushNamed(context, AppRoutes.home);
  }
}
