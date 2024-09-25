// lib/presentation/login/login_viewmodel.dart
import 'package:aurudu_nakath/features/ui/Login/domain/entitise/user_entity.dart';
import 'package:aurudu_nakath/features/ui/Login/domain/usecase/sign_in_with_google.dart';
import 'package:flutter/material.dart';


class LoginViewModel extends ChangeNotifier {
  final SignInWithGoogle signInWithGoogle;
  UserEntity? user;

  LoginViewModel({required this.signInWithGoogle});

  Future<void> login() async {
    user = await signInWithGoogle();
    notifyListeners();
  }
}
