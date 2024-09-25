// lib/presentation/login/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await loginViewModel.login();
            // Navigate to the next screen after login
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
