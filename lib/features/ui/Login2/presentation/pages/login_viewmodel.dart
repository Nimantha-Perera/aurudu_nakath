import 'package:aurudu_nakath/features/ui/Login2/data/modal/user_model.dart';
import 'package:aurudu_nakath/features/ui/Login2/domain/usecase/sign_in_with_google.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel2 extends ChangeNotifier {
  final SignInWithGoogle2 _signInWithGoogle;
  CustomUser2? _user;
  bool _isLoading = false; // To manage loading state

  LoginViewModel2(this._signInWithGoogle);

  CustomUser2? get user => _user;
  bool get isLoading => _isLoading;

  /// Logs in the user using Google Sign-In
  Future<void> login() async {
    _isLoading = true; // Set loading state to true
    notifyListeners();

    try {
      User? firebaseUser = await _signInWithGoogle.signIn();
      if (firebaseUser != null) {
        _user = CustomUser2(
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName ?? '',
          photoURL: firebaseUser.photoURL,
          id: firebaseUser.uid,
        );

        // Save user details in SharedPreferences
        await _saveUserDetails();
      }
    } catch (e) {
      print("Login failed: $e");
      // Handle specific error cases if needed (e.g., cancellation)
      if (e is FirebaseAuthException) {
        // Handle Firebase specific errors if required
      }
      _user = null; // Reset user on failure
    } finally {
      _isLoading = false; // Reset loading state
      notifyListeners();
    }
  }

  /// Saves user details in SharedPreferences
  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _user!.email);
    await prefs.setString('displayName', _user!.displayName);
    await prefs.setString('photoURL', _user!.photoURL ?? '');
    await prefs.setString('userId', _user!.id ?? '', );
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
