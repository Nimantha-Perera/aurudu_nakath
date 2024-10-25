import 'package:aurudu_nakath/features/ui/Login/data/modal/user_model.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/usecase/sign_in_with_google.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;
  CustomUser? _user;
  bool _isLoading = false; // To manage loading state

  LoginViewModel(this._signInWithGoogle);

  CustomUser? get user => _user;
  bool get isLoading => _isLoading;

  /// Logs in the user using Google Sign-In and saves data in Firestore
  Future<void> login() async {
    _isLoading = true; // Set loading state to true
    notifyListeners();

    try {
      final result = await _signInWithGoogle.signIn();

      if (result != null) {
        // The result contains access token, id token, email, display name, and photo URL
        _user = CustomUser(
          email: result['email']!,
          displayName: result['displayName']!,
          photoURL: result['photoUrl'],
          id: result['idToken'], // You can use idToken or accessToken as user ID or for verification
        );

        // Save user details in Firestore
        await _saveUserDetailsToFirestore();

        // Save user details in SharedPreferences
        await _saveUserDetailsToSharedPreferences();
      }
    } catch (e) {
      print("Login failed: $e");
      _user = null; // Reset user on failure
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  /// Saves user details in Firestore
  Future<void> _saveUserDetailsToFirestore() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a user document in 'users' collection using the user's ID (idToken in this case)
    await firestore.collection('google_authed_users').doc(_user!.id).set({
      'email': _user!.email,
      'displayName': _user!.displayName,
      'photoURL': _user!.photoURL,
      'createdAt': Timestamp.now(),
      'userId': _user!.id, // Use the user ID as the document ID
    });
  }

  /// Saves user details in SharedPreferences
  Future<void> _saveUserDetailsToSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _user!.email);
    await prefs.setString('displayName', _user!.displayName);
    await prefs.setString('photoURL', _user!.photoURL ?? '');
    await prefs.setString('userId', _user!.id ?? '');
  }

  /// Checks the login status of the user and returns a bool indicating if logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email != null; // Return true if the email exists
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
