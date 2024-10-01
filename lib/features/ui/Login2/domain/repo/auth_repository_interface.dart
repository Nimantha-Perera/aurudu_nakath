// lib/domain/repositories/auth_repository_interface.dart
import 'package:aurudu_nakath/features/ui/Login2/domain/entitise/user_entity.dart';



abstract class AuthRepositoryInterface2 {
  Future<UserEntity2?> signInWithGoogle();
}
