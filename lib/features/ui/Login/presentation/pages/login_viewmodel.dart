// lib/presentation/login/login_viewmodel.dart
import 'package:aurudu_nakath/features/ui/Login/data/modal/user_model.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/usecase/sign_in_with_google.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle _signInWithGoogle;
  CustomUser? _user;

  LoginViewModel(this._signInWithGoogle);

  CustomUser? get user => _user;

  /// Logs in the user using Google Sign-In
  Future<void> login() async {
    try {
      User? firebaseUser = await _signInWithGoogle.signIn();
      if (firebaseUser != null) {
        _user = CustomUser(
          email: firebaseUser.email!,
          displayName: firebaseUser.displayName ?? '',
          photoURL: firebaseUser.photoURL,
        );

        // Save user details in SharedPreferences
        await _saveUserDetails();
      }
      notifyListeners(); // Notify listeners to update the UI
    } catch (e) {
      print("Login failed: $e");
    }
  }

  /// Saves user details in SharedPreferences
  Future<void> _saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', _user!.email);
    await prefs.setString('displayName', _user!.displayName);
    await prefs.setString('photoURL', _user!.photoURL ?? '');
  }

  /// Checks the login status of the user and returns a bool indicating if logged in
  Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    return email != null; // Return true if the email exists
  }

  /// Logs out the user and clears their information
  Future<void> logout() async {
    await _signInWithGoogle.signOut();
    _user = null; // Clear user info

    // Clear SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    notifyListeners(); // Notify listeners to update the UI
  }
}
