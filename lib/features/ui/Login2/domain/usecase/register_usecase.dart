import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterUseCase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> registerUser({
    required String username,
    required String email,
    required String password,
    required String mobile,
  }) async {
    try {
      // Check if the username is already taken
      final QuerySnapshot usernameSnapshot = await _firestore
          .collection('normle_users')
          .where('username', isEqualTo: username)
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        return 'Username already exists';
      }

      // Check if the email is already registered in Firebase Authentication
      final List<String> methods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (methods.isNotEmpty) {
        return 'Email already registered';
      }

      // Register the user with Firebase Authentication
      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      final User? user = userCredential.user;

      if (user != null) {
        // Save user details to Firestore
        await _firestore.collection('normle_users').doc(user.uid).set({
          'username': username.trim(),
          'email': email.trim(),
          'mobile': mobile.trim(),
          'reg_date': DateTime.now().toString(),
          'uid': user.uid,
        });

        return 'success'; // Successfully registered
      }

      return 'Registration failed';
    } on FirebaseAuthException catch (e) {
      return _handleAuthErrors(e);
    } catch (e) {
      return 'An unknown error occurred: $e';
    }
  }

  String? _handleAuthErrors(FirebaseAuthException e) {
    if (e.code == 'email-already-in-use') {
      return 'This email address is already in use.';
    } else if (e.code == 'weak-password') {
      return 'The password provided is too weak.';
    } else if (e.code == 'invalid-email') {
      return 'The email address is not valid.';
    } else {
      return 'Registration error: ${e.message}';
    }
  }
}
