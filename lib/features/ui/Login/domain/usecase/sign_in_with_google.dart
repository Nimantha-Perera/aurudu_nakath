import 'package:google_sign_in/google_sign_in.dart';

class SignInWithGoogle {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  SignInWithGoogle();

  // Sign-in method without Firebase authentication
  Future<Map<String, String>?> signIn() async {
    try {
      // Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // Retrieve authentication tokens
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Return the access token and ID token (can be sent to your server for verification)
      return {
        'accessToken': googleAuth.accessToken!,
        'idToken': googleAuth.idToken!,
        'email': googleUser.email,
        'displayName': googleUser.displayName ?? '',
        'photoUrl': googleUser.photoUrl ?? ''
      };
    } catch (error) {
      // Handle sign-in errors here
      print("Error signing in with Google: $error");
      return null;
    }
  }

  // Sign-out method
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
