import 'package:aurudu_nakath/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';


import '../intro_screens/screen1.dart';
import '../intro_screens/screen2.dart';
import '../intro_screens/screen3.dart';
import 'home.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  PageController _controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  onLastPage = (index == 2);
                });
              },
              children: [IntroPage1(), IntroPage2(), IntroPage3()],
            ),
            Container(
                alignment: Alignment(0, 0.75),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(


                      style: ElevatedButton.styleFrom(

                        minimumSize: Size(100, 40), backgroundColor: Colors.white,


                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0), // Adjust as needed
                        ),
                        // Main button color

                      ),
                      onPressed: () {
                        // Your onTap function logic goes here
                        _controller.jumpToPage(2);
                        // Add more code as needed
                      },
                      child: Text(
                        "මඟ හරින්න",
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                      ),
                    ),

                    SmoothPageIndicator(
                      controller: _controller, // your PageController
                      count: 3, // total number of pages
                      axisDirection: Axis.horizontal, // or AxisDirection.down
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.grey, // color of inactive dots
                        activeDotColor: Colors.white, // color of the active dot
                        dotHeight: 8, // size of inactive dots
                        dotWidth: 8, // size of active dot
                        spacing: 8, // space between dots
                      ),
                    ),

                    onLastPage
                        ? ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        minimumSize: Size(100, 40), backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0), // Adjust as needed
                        ),
                        // Main button color

                      ),
                      onPressed: () {
                        // Handle the "done" button tap on the last page
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return SplashScreen();
                        }));
                      },
                      child: Text(
                        "අවසන්",
                        style: GoogleFonts.notoSerifSinhala(fontSize: 14, color: Colors.black38),
                      ),
                    )
                        : ElevatedButton(
                      style: ElevatedButton.styleFrom(

                        minimumSize: Size(100, 40), backgroundColor: Colors.white,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0), // Adjust as needed
                        ),
                        // Main button color

                      ),
                      onPressed: () {
                        _controller.nextPage(
                            duration: Duration(milliseconds: 200), curve: Curves.easeIn);
                      },
                      child: Text(
                        "ඉදිරියට",
                        style: GoogleFonts.notoSerifSinhala(fontSize: 14, color: Colors.black38),
                      ),
                    )

                  ],
                ))
          ],
        ));
  }
}
