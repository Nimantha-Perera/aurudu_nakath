import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background Color Matching the Image (Blue shade)
      backgroundColor: Color(0xFF9B3D71),
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
                  child: Lottie.network(
                    "https://lottie.host/d77386d7-26a3-475e-a271-1083e2861fb3/Jw8dkbxlfj.json", // Replace with the correct path to your SVG file
                    height: 300,
                    width: 300,
                    repeat: false,
                  ),
                ),

                SizedBox(height: 100),

                // Title - Updated Text Matching the Image
              

                // Subtitle
                Text(
                  "හෙළ කෘතීම බුද්ධිය භාවිතයෙන් ඔබට නොදන්නා දේවල් දැනගන්න සහ විවිධ ගැටලු වලට පිලිතුරු ලබාගන්න පුලුවන්.",
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
