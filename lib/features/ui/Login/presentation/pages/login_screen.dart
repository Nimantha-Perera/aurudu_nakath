import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    
    return Scaffold(
      body: Container(
        
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(),
                    SizedBox(height: 40),
                    _buildWelcomeText(),
                    SizedBox(height: 50),
                    _buildGoogleSignInButton(context, loginViewModel),
                    SizedBox(height: 20),
                    _buildSignUpLink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.auto_awesome,
          size: 60,
          color: Colors.indigo.shade800,
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Hela GPT',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'ඔබගේ ජ්‍යෝතීශ්‍ය සහය',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 18,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, LoginViewModel loginViewModel) {
    return ElevatedButton.icon(
      // icon: Image.asset('assets/images/google_logo.png', height: 24),
      label: Text(
        'Sign in with Google',
        style: TextStyle(fontSize: 16, color: Colors.indigo.shade800),
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
      onPressed: () => _handleSignIn(context, loginViewModel),
    );
  }

  Widget _buildSignUpLink() {
    return TextButton(
      onPressed: () {
        // Navigate to sign-up screen if needed
        // Navigator.pushNamed(context, AppRoutes.signup);
      },
      child: Text(
        'Don\'t have an account? Sign Up',
        style: TextStyle(color: const Color.fromARGB(255, 90, 90, 90), fontSize: 16),
      ),
    );
  }

  void _handleSignIn(BuildContext context, LoginViewModel loginViewModel) async {
    try {
      await loginViewModel.login();
      if (loginViewModel.user != null) {
        final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
        
        if (subscriptionProvider.isSubscribed) {
          Navigator.pushReplacementNamed(context, AppRoutes.helagptPro);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.helagptnormless);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    }
  }
}