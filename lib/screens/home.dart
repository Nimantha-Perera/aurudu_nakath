import 'package:aurudu_nakath/Ads/constombannerad.dart';
import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';
import 'package:aurudu_nakath/screens/help.dart';
import 'package:aurudu_nakath/screens/horoscope/menu.dart';
import 'package:aurudu_nakath/screens/raahu_kalaya.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'aurudu_nakath.dart';
import 'lagna.dart';
import 'nakath_sittuwa.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

InterstitialAdManager adManager = InterstitialAdManager();

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    // Initialize the interstitial ad when the widget is created
    adManager.initInterstitialAd();
  }

  Future<bool> _onWillPop() async {
    // Show ad when the back button is pressed
    if (await adManager.isInterstitialAdLoaded()) {
      adManager.showInterstitialAd();
      return false; // Prevent the app from closing immediately
    }
    return true; // Allow the app to close if the ad is not loaded
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          mini: true,
          onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Help();
                  },
                ),
              ),
          child: Icon(Icons.help)),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/bg/iPhone SE - 2.png',
              fit: BoxFit.cover,
            ),
          ),

          Container(
            margin: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    margin: EdgeInsets.only(
                        left: 20, top: 20), // Adjust the top value as needed
                    child: Text(
                      'නැකැත් App වෙත,\nසාදරයෙන් පිලිගනිමු',
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //Ads Load
                            // adManager.showInterstitialAd();

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return NakathSittuwa();
                                },
                              ),
                            );
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
                                      Color.fromARGB(255, 255, 87,
                                          34), // Modify these colors as needed
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      child: Center(
                                        child: Text(
                                          'අවුරුදු නැකැත්',
                                          style: GoogleFonts.notoSerifSinhala(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontWeight: FontWeight
                                                .bold, // Add this line to make the text bold
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                            //Ads Load
                            // adManager.showInterstitialAd();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return AuruduNakathScreen();
                                },
                              ),
                            );
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
                                      Color.fromARGB(255, 255, 87,
                                          34), // Modify these colors as needed
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        '2024 ලිත',
                                        style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight
                                              .bold, // Add this line to make the text bold
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //Ads Load
                            // adManager.showInterstitialAd();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return LagnaPalapala();
                                },
                              ),
                            );
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
                                      Color.fromARGB(255, 255, 87,
                                          34), // Modify these colors as needed
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        'ලග්න පලාඵල',
                                        style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight
                                              .bold, // Add this line to make the text bold
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                        child: InkWell(
                          onTap: () {
                            // Handle tap for "රාහු කාලය"
                            //Ads Load
                            // adManager.showInterstitialAd();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return RaahuKaalaya();
                                },
                              ),
                            );
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
                                      Color.fromARGB(255, 255, 87,
                                          34), // Modify these colors as needed
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        'රාහු කාලය',
                                        style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight
                                              .bold, // Add this line to make the text bold
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            //Ads Load
                            // adManager.showInterstitialAd();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return HelaChatAI();
                                },
                              ),
                            );
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
                                      Color.fromARGB(255, 255, 87,
                                          34), // Modify these colors as needed
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        'හෙල AI',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight
                                              .bold, // Add this line to make the text bold
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                            //Ads Load
                            // adManager.showInterstitialAd();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return Menu();
                                },
                              ),
                            );
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
                                        'ජ්‍යෝතීෂ්‍ය සේවාව',
                                        style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14,
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    // Adding the image at the bottom
                                    Positioned(
                                      bottom: 60,
                                      left: 0,
                                      right: 0,
                                      child: Opacity(
                                        opacity:
                                            0.2, // Adjust opacity value between 0.0 and 1.0
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
                ],
              ),
            ),
          ),
          // Container(
          //   child: CustomBannerAd(
          //     adSize: AdSize.banner,
          //     adUnitId: 'ca-app-pub-7834397003941676/2610223957',
          //   ),
          // )
        ],
      ),
    );
  }
}
