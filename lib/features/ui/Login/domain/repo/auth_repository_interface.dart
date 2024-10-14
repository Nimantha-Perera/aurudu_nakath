// lib/domain/repositories/auth_repository_interface.dart
import 'package:aurudu_nakath/features/ui/Login/domain/entitise/user_entity.dart';



abstract class AuthRepositoryInterface {
  Future<UserEntity?> signInWithGoogle();
}
