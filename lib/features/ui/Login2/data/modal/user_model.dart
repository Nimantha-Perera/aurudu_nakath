// lib/models/custom_user.dart
class CustomUser2 {
  final String email;
  final String displayName;
  final String? photoURL;
  final String? id;

  CustomUser2({
    required this.email,
    required this.displayName,
    this.photoURL,
    this.id,
  });
}
