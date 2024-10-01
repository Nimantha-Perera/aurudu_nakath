import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';

class LoginRegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel2>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: Colors.indigo.shade800,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.indigo.shade800,
            tabs: [
              Tab(text: 'පූර්ණය වන්න'),
              Tab(text: 'නව ගිනුමක් සාදන්න'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildLoginScreen(context, loginViewModel),
            _buildRegisterScreen(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginScreen(BuildContext context, LoginViewModel2 loginViewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          _buildLogo(),
          SizedBox(height: 40),
          _buildWelcomeText(),
          SizedBox(height: 50),
          TextField(
            decoration: InputDecoration(
              labelText: 'ඊමේල් ලිපිනය',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'රහස්‍ය අංකය',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
                showDialog(context: context, builder: (context) => AlertDialog(content: Text('Forgot Password functionality coming soon!')));
              },
              child: Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.indigo.shade800),
              ),
            ),
          ),
          SizedBox(height: 20),
          _buildGoogleSignInButton(context, loginViewModel),
        ],
      ),
    );
  }

  Widget _buildRegisterScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      
          SizedBox(height: 50),
          TextField(
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
  width: double.infinity,  // This will make the button's width full
  child: ElevatedButton(
    onPressed: () {
      // Handle registration
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(content: Text('Registration functionality coming soon!'))
      );
    },
    child: Text('Register', style: TextStyle(fontSize: 16)),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo.shade800,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
    ),
  ),
)

        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/icons/katapatha.webp')),
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
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'කැටපත',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'ඔබගේ නිර්මාණශීලීත්වය අගය කිරීම සඳහා',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSerifSinhala(
              fontSize: 15,
              color: const Color.fromARGB(255, 90, 90, 90),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context, LoginViewModel2 loginViewModel) {
    return ElevatedButton.icon(
      icon: Icon(FontAwesomeIcons.google, color: Colors.indigo.shade800),
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

  void _handleSignIn(BuildContext context, LoginViewModel2 loginViewModel) async {
    try {
      await loginViewModel.login();
      Navigator.pushReplacementNamed(context, AppRoutes.katapatha);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed. Please try again.')),
      );
    }
  }
}
