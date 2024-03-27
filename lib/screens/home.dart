import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aurudu_nakath/Ads/constombannerad.dart';
import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';
import 'package:aurudu_nakath/screens/help.dart';
import 'package:aurudu_nakath/screens/horoscope/compass.dart';
import 'package:aurudu_nakath/screens/horoscope/menu.dart';
import 'package:aurudu_nakath/screens/raahu_kalaya.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'aurudu_nakath.dart';
import 'lagna.dart';
import 'nakath_sittuwa.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool showImage = false;

InterstitialAdManager adManager = InterstitialAdManager();

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    // Initialize the interstitial ad when the widget is created
    adManager.initInterstitialAd();
    ImageUtils.precacheImage(context);
    checkFirebaseDatabase();
  }

  Future<bool> _onWillPop() async {
    // Show ad when the back button is pressed
    if (await adManager.isInterstitialAdLoaded()) {
      adManager.showInterstitialAd();
      return false; // Prevent the app from closing immediately
    }
    return true; // Allow the app to close if the ad is not loaded
  }

// Method to check Firebase database value
// Method to check Firebase database value
  void checkFirebaseDatabase() {
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.reference().child('happy_new_year');

    // Use 'onValue' instead of 'once' to receive a continuous stream of events
    databaseReference
        .child('check_value')
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        bool firebaseBoolValue = event.snapshot.value as bool;

        // Update the UI based on the boolean value
        setState(() {
          showImage = firebaseBoolValue;
        });
      } else {
        // Handle the case where the snapshot is null or doesn't contain data
        print('Firebase database value is null or does not contain data');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
          animatedIcon: AnimatedIcons.menu_close,
          children: [
            SpeedDialChild(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                child: Icon(Icons.help),
                label: 'උදව්',
                labelStyle: GoogleFonts.notoSerifSinhala(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Help()),
                  );
                }),
            SpeedDialChild(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                child: Icon(Icons.compass_calibration),
                label: 'මාලිමාව',
                labelStyle: GoogleFonts.notoSerifSinhala(),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Compass()),
                  );
                })
          ]),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Image.asset(
              'assets/bg/iPhone SE - 2.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: FutureBuilder(
              future: rootBundle.loadString('assets/index.html'),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Html(
                    data: snapshot.data,
                  );
                } else {
                  return CircularProgressIndicator(); // or any other loading indicator
                }
              },
            ),
          ),
          // Positioned(
          //   top: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     child: CustomBannerAd(
          //       adSize: AdSize.banner,
          //       adUnitId: 'ca-app-pub-7834397003941676/2610223957',
          //     ),
          //   ),
          // ),
          Container(
            margin: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showImage == false)
                    Container(
                      padding: EdgeInsets.only(bottom: 50),
                      margin: EdgeInsets.only(
                          left: 0, top: 20), // Adjust the top value as needed
                      child: SizedBox(
                        height: 30,
                        child: FadeAnimatedTextKit(
                          text: [
                            'නැකැත් App වෙත',
                            'සාදරයෙන් පිලිගනිමු',
                          ],
                          textStyle: GoogleFonts.notoSerifSinhala(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  else if (showImage == true)
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 50),
                        margin: EdgeInsets.only(
                            left: 0, top: 20), // Adjust the top value as needed
                        child: SizedBox(
                          height: 30,
                          width: 250.0,
                          child: DefaultTextStyle(
                            style: GoogleFonts.notoSerif(
                              textStyle: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            child: Center(
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TyperAnimatedText(
                                    'සාමය සතුට සපිරුනු',
                                    textStyle: GoogleFonts.notoSerifSinhala(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  TyperAnimatedText(
                                    'ඔබ සැමට',
                                    textStyle: GoogleFonts.notoSerifSinhala(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  TyperAnimatedText(
                                    'සුභ අලුත් අවුරුද්දක් වේවා',
                                    textStyle: GoogleFonts.notoSerifSinhala(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ],
                                onTap: () {
                                  print("Tap Event");
                                },
                              ),
                            ),
                          ),
                        ),
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
        ],
      ),
    );
  }
}
