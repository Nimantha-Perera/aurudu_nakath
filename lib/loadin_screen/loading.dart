import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo or image for branding
            // Hero(
            //   tag: 'appLogo',
            //   child: Image.asset(
            //     'assets/logo.png', // Replace with your logo or asset
            //     width: 100,
            //     height: 100,
            //   ),
            // ),
            SizedBox(height: 40),
            // Circular progress indicator with smooth animation
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
              strokeWidth: 4,
            ),
            SizedBox(height: 24),
            // Custom text style for 'Loading...'
            Text(
              'රැඳී සිටින්න...',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            SizedBox(height: 8),
            // Subtle animated text
            _buildAnimatedDots(),
          ],
        ),
      ),
    );
  }

  // Animated text that adds visual interest
  Widget _buildAnimatedDots() {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(seconds: 1),
      builder: (context, value, child) {
        int dotsCount = (value * 3).floor(); // Show 1-3 dots based on animation
        String dots = '.' * dotsCount;
        return Text(
          'Loading$dots',
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        );
      },
      onEnd: () => setState(() {}), // SetState triggers rebuild safely
    );
  }
}
