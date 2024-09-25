// lib/models/custom_user.dart
class CustomUser {
  final String email;
  final String displayName;
  final String? photoURL;

  CustomUser({
    required this.email,
    required this.displayName,
    this.photoURL,
  });
}
