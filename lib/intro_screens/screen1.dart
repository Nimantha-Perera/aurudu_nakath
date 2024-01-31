import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            // Background Gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber, Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Content Overlay
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          Text(
                            "Welcome to the නැකැත් App",
                            style: GoogleFonts.notoSerifSinhala(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Description
                    Text(
                      "නැකැත් App වෙත ඔබව සාදරයෙන් පිලිගන්නවා නවීන ලෝකයේ දියුනු තාක්ශනයත් සමඟ අප ශ්‍රී ලංකාවේ නැකැත් සඳහා කරනලද නිමැවුමයි මේ",
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 20),

                    // Lottie Animation
                    Lottie.network(
                      'https://lottie.host/5a974723-a527-4248-aaca-856907a99035/FcQ82eGMY4.json',
                      height: 400,
                      repeat: false,
                      width: 400,
                    ),

                    SizedBox(height: 40),
                    // Customizable content goes here
                    // You can add buttons, images, or any other widgets as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
