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
                    _buildSignUpLink(context),
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
    image: DecorationImage(image: AssetImage('assets/icons/lion.webp')),
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
  // child: Center(
  //   child: Image.asset(
  //     'assets/icons/lion.webp', // Replace with your image path
  //     width: 100, // Set the width of the image
  //     height: 60, // Set the height of the image
  //     fit: BoxFit.cover, // Adjust the image fit as necessary
  //   ),
  // ),
);

  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'හෙළ GPT',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'ඔබගේ තාක්ශනික සහායක',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 18,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),

        Text(
          'හෙළ GPT භාවිතාකිරීම සඳහා පූර්නය වන්න',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 12,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, LoginViewModel loginViewModel) {
    return ElevatedButton.icon(
      label: loginViewModel.isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(color: Colors.indigo.shade800, strokeWidth: 2),
            )
          : Text(
              'Google සමගින් පූර්ණය වන්න',
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
      onPressed: loginViewModel.isLoading ? null : () => _handleSignIn(context, loginViewModel),
    );
  }

  Widget _buildSignUpLink(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Navigate to sign-up screen if needed
        // Navigator.pushNamed(context, AppRoutes.signup);
        showDialog(context: context, builder: (context) => AlertDialog(content: Text('කරුනාකර Google සමඟින් පූර්ණය වන්න'),));
      },
      child: Text(
        'ඔයාට ගිනුමක් නැද්ද? Sign Up',
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
      // Show error message if login fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    }
  }
}
