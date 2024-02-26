import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 100,left: 50,right: 50),
           
            child: Text(
              "නැකැත් App එක වෙත පිවිසීමේදී\n ඔබේ අන්තර්ජාල සබඳතාව On එකේ තිබිය යුතුයි",
              style: GoogleFonts.notoSerifSinhala(
                fontSize: 15,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
           
            child: Lottie.network(
              'https://lottie.host/c709618b-400d-4773-9f6d-d266522baedf/8F9nYGiIv7.json',
              height: 400,
              width: 400,
            ),
          ),
        ],
      ),
    );
  }
}
