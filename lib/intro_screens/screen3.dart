import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
        colors: [Colors.amber, Colors.orange],
      )),
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 60),
              child: Text(
                "සියල්ල අවසන් \n අපි ඉදිරියට යන්",
                style: GoogleFonts.notoSerifSinhala(
                    fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
                // margin: EdgeInsets.only(top: 100, bottom: 100),
                // child: Image.asset(
                //   'asset/Children-pana.png', // Replace with the correct path to your SVG file
                //   height: 300,
                //   width: 300,
                // ),
                ),
            Container(
              margin: EdgeInsets.only(top: 50, bottom: 100),
              child: Lottie.network(
                'https://lottie.host/d2cd9cd5-a8c8-4f7f-99e2-311ac89e512c/qLHXo6zjww.json', // Replace with the correct path to your PNG file
                height: 200,
                repeat: false,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
