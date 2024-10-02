// google_login.dart
import 'package:aurudu_nakath/features/ui/Login2/presentation/pages/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';


class GoogleLoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel2>(context);

    return ElevatedButton.icon(

      icon: Icon(FontAwesomeIcons.google, color: Color.fromARGB(255, 109, 109, 109)),
      label: loginViewModel.isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(color: Color.fromARGB(255, 109, 109, 109), strokeWidth: 2),
            )
          : Text(
              'Google සමගින් පූර්ණය වන්න',
              style: TextStyle(fontSize: 16, color: const Color.fromARGB(255, 109, 109, 109)),
            ),
      style: ElevatedButton.styleFrom(
      
        backgroundColor: Colors.white,
        foregroundColor: Colors.indigo.shade800,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
      ),
      onPressed: loginViewModel.isLoading ? null : () => _handleSignIn(context, loginViewModel),
    );
  }

  void _handleSignIn(BuildContext context, LoginViewModel2 loginViewModel) async {
    try {
      await loginViewModel.login();
      Navigator.pushReplacementNamed(context, '/katapatha');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    }
  }
}
