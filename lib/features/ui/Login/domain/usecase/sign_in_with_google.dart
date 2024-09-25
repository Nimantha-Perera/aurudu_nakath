// lib/domain/usecases/sign_in_with_google.dart
import 'package:aurudu_nakath/features/ui/Login/domain/entitise/user_entity.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/repo/auth_repository_interface.dart';



class SignInWithGoogle {
  final AuthRepositoryInterface repository;

  SignInWithGoogle(this.repository);

  Future<UserEntity?> call() {
    return repository.signInWithGoogle();
  }
}
