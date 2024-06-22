import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToolsScreen extends StatelessWidget {
  const ToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg', // Replace with your image path
              fit: BoxFit.cover,
            ),
          ),
          // Centered buttons
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Ads Load
                        // adManager.showInterstitialAd();
                        Navigator.of(context).pushNamed('/malimawa');
                      },
                      child: Container(
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          color: Color.fromARGB(255, 248, 190, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 248, 190, 0),
                                  Color.fromARGB(255, 255, 87, 34),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'මාලිමාව',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.notoSerifSinhala(
                                      fontSize: 14,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 60,
                                  left: 0,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Image.asset(
                                      'assets/Mandala2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Ads Load
                        // adManager.showInterstitialAd();
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) {
                        //       return Menu();
                        //     },
                        //   ),
                        // );
                        Navigator.of(context).pushNamed('/help');
                      },
                      child: Container(
                        height: 100,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          elevation: 5,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 248, 190, 0),
                                  Color.fromARGB(255, 255, 87, 34),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    'උදව්',
                                    style: GoogleFonts.notoSerifSinhala(
                                      fontSize: 14,
                                      color: const Color.fromARGB(255, 255, 255, 255),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 60,
                                  left: 0,
                                  right: 0,
                                  child: Opacity(
                                    opacity: 0.2,
                                    child: Image.asset(
                                      'assets/Mandala2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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
