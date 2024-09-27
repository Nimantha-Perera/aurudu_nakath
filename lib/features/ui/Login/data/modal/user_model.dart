// lib/models/custom_user.dart
class CustomUser {
  final String email;
  final String displayName;
  final String? photoURL;
  final String? id;

  CustomUser({
    required this.email,
    required this.displayName,
    this.photoURL,
    this.id,
  });
}
