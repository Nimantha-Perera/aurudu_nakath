import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color Matching the Image (Blue shade)
      backgroundColor: Color(0xFF107077),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Lottie Animation in place of the image
                Container(
                  margin: EdgeInsets.only(top: 0),
                  child: Image.asset(
                    'assets/new_images/intro3.png', // Replace with the correct path to your SVG file
                    height: 300,
                    width: 300,
                  ),
                ),

                SizedBox(height: 100),

                // Title - Updated Text Matching the Image
              

                // Subtitle
                Text(
                  "නැකැත් යෙදුම වෙත ඔබව සාදරයෙන් පිලිගනිමු.",
                  style: GoogleFonts.notoSerifSinhala(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
