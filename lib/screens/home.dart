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
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aurudu_nakath.dart';
import 'lagna.dart';
import 'nakath_sittuwa.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

bool showImage = false;

int myCurrentIndex = 0;

InterstitialAdManager adManager = InterstitialAdManager();

late Timer timer;
late DateTime futureDate1;
late DateTime futureDate2;

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    loadImages();
    // Initialize the interstitial ad when the widget is created
    adManager.initInterstitialAd();
    ImageUtils.precacheImage(context);
    checkFirebaseDatabase();

    countdownText1 = 'ගනනය කරමින්...';
    countdownText2 = 'ගනනය කරමින්...';
    ImageUtils.precacheImage(context);

    // Future dates
    futureDate1 = DateTime(2024, 4, 13);
    futureDate2 = DateTime(2024, 4, 13, 21, 5);

    // Initialize timer to update countdown every second
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        // Recalculate the differences every second
        Duration difference1 = futureDate1.difference(DateTime.now());
        Duration difference2 = futureDate2.difference(DateTime.now());

        updateCountdown(1, difference1); // Update the first countdown
        updateCountdown(2, difference2); // Update the second countdown
      });
    });
  }

  late String countdownText1;
  late String countdownText2;

  void updateCountdown(int counterIndex, Duration difference) {
    String countdownText;

    if (difference.inSeconds <= 0) {
      countdownText = 'අලුත් අවුරුදු ලබා අවසන්';
    } else {
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;

      countdownText =
          'දින: $days  පැය: $hours  මිනිත්තු: $minutes  තත්පර: $seconds';
    }

    // Assign the appropriate countdown text based on the counter index
    if (counterIndex == 1) {
      setState(() {
        // Assign the countdown text for the first counter
        countdownText1 = countdownText;
      });
    } else if (counterIndex == 2) {
      setState(() {
        // Assign the countdown text for the second counter
        countdownText2 = countdownText;
      });
    }
  }

  Future<bool> _onWillPop() async {
    // Show ad when the back button is pressed
    if (await adManager.isInterstitialAdLoaded()) {
      adManager.showInterstitialAd();
      return false; // Prevent the app from closing immediately
    }
    return true; // Allow the app to close if the ad is not loaded
  }

  List<Widget> myItems = [];

  // Asynchronously loads images from Firebase Storage and adds them to myItems to be displayed.
  void loadImages() async {
    // Initialize Firebase Storage instance
    FirebaseStorage storage = FirebaseStorage.instance;
    // Example path to your images in Firebase Storage
    String path = 'image_slider'; // Change this to your actual path
    // Get reference to the folder
    Reference ref = storage.ref().child(path);
    // List all the items in the folder
    ListResult result = await ref.listAll();
    // Iterate through each item and add it to myItems
    result.items.forEach((Reference imageRef) async {
      // Get the download URL for each image
      String imageUrl = await imageRef.getDownloadURL();
      // Create an Image widget with the retrieved URL
      setState(() {
        myItems.add(Image.network(imageUrl));
      });
    });
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
    return RefreshIndicator(
      onRefresh: () => _onWillPop(),
      child: Scaffold(
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
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: GestureDetector(
            //     onTap: () async {
            //       const url =
            //           'https://play.google.com/store/apps/details?id=com.hela_ai.hela_ai'; // Replace this with your link
            //       if (await canLaunch(url)) {
            //         await launch(url);
            //       } else {
            //         throw 'Could not launch $url';
            //       }
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Container(
            //         margin: EdgeInsets.only(top: 10),
            //         child: Image.asset('assets/helagpt_bannerad.png'),
            //       ),
            //     ),
            //   ),
            // ),
            Container(
              width: double.infinity,
              height: 150,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ලඟම නැකත",
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 16,
                        color: Color.fromARGB(255, 255, 187, 0),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 207, 207, 207), // Choose your desired border color
                            width: 2.0, // Adjust the border width as needed
                          ),
                          borderRadius: BorderRadius.circular(
                              10.0), // Adjust the border radius as needed
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                'අලුත් අවුරුදු උදාවිමට තව',
                                style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "$countdownText1",
                                style: GoogleFonts.notoSerifSinhala(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 100, left: 20, right: 20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Row(
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
                                              style:
                                                  GoogleFonts.notoSerifSinhala(
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
      ),
    );
  }
}
