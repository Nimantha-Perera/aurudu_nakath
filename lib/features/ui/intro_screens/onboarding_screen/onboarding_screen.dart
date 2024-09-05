import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../intro/screen1.dart';
import '../intro/screen2.dart';
import '../intro/screen3.dart';
import '../../../../screens/home.dart';
import '../../../../screens/splash_screen.dart';

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
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              // Remove background color and border radius
              color: Colors.transparent, 
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Transparent button
                  TextButton(
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      "මඟ හරින්න",
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 14,
                        color: Colors.white, // White text to stand out
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller, // your PageController
                    count: 3, // total number of pages
                    axisDirection: Axis.horizontal,
                    effect: ExpandingDotsEffect(
                      dotColor: Colors.grey.shade300, // Inactive dots
                      activeDotColor: Colors.white, // Active dot
                      dotHeight: 8,
                      dotWidth: 8,
                      spacing: 8,
                    ),
                  ),
                  onLastPage
                      ? TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return SplashScreen();
                            }));
                          },
                          child: Text(
                            "අවසන්",
                            style: GoogleFonts.notoSerifSinhala(
                              fontSize: 14,
                              color: Colors.white, // White text
                            ),
                          ),
                        )
                      : TextButton(
                          onPressed: () {
                            _controller.nextPage(
                                duration: Duration(milliseconds: 200),
                                curve: Curves.easeIn);
                          },
                          child: Text(
                            "ඉදිරියට",
                            style: GoogleFonts.notoSerifSinhala(
                              fontSize: 14,
                              color: Colors.white, // White text
                            ),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
