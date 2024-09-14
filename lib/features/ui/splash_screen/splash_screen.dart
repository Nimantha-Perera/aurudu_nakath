import 'package:aurudu_nakath/features/ui/home/presentation/pages/dash_board.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add any initialization tasks here
    // For example, you can load data, check authentication, etc.

    // After a certain duration, you can navigate to the main screen
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashBoard()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text(
            'නැකැත්',
            style: GoogleFonts.notoSerifSinhala(
              fontSize: 34,
              color: Color.fromARGB(255, 255, 208, 0),
              fontWeight:
                  FontWeight.bold, // Add this line to make the text bold
            ),
          ),
        ),
      ),
    );
  }
}
