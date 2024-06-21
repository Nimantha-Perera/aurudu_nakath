import 'dart:async';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aurudu_nakath/Ads/constombannerad.dart';
import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/Notifications/notification_service.dart';
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

bool showTimeCount = true;

int myCurrentIndex = 0;

InterstitialAdManager adManager = InterstitialAdManager();
NotificationService notificationService = NotificationService();

List<DateTime> _targetDates = [
  DateTime(2024, 4, 11),
  DateTime(2024, 4, 13, 14, 41),
  DateTime(2024, 4, 13, 21, 5),
  DateTime(2024, 4, 13, 23, 6),
  DateTime(2024, 4, 14, 00, 6),
  DateTime(2024, 4, 15, 10, 17),
  DateTime(2024, 4, 17, 6, 52),
  DateTime(2024, 4, 18, 10, 16),
];

List<String> indexNames = [
  'නව සඳ බැලීම සහ පරන අවුරුද්ද සඳහා ස්නානයට තව',
  'පුණ්‍ය කාලය සඳහා තව',
  'සිංහල දෙමළ අලුත් අවුරුද්ද උදාව සඳහා තව',
  'කිරි ඉතිරවීම සඳහා තව',
  'වැඩ ඇල්ලීම ,හනුදෙනු කිරීම සහ ආහාර අනුභවය',
  'හිස තෙල් ගෑම සඳහා තව',
  'රැකී රක්ශා සඳහා පිටත්ව යෑම සඳහා තව',
  'පැල සිටුවීම සඳහා තව',
];

// String getEventName(int index) {
//   if (index >= 0 && index < indexNames.length) {
//     return indexNames[index];
//   } else {
//     return 'Unknown Event';
//   }
// }

// int _currentIndex = 0;
// String _timeUntil = '';

class _HomeScreenState extends State<HomeScreen> {
  void initState() {
    super.initState();
    notificationService.initialize();

    notificationService.getFcmToken().then((value) {
      print("Token: $value");
    });
    notificationService.onTokenRefresh();
    loadImages();
    // _startTimer();
    // Initialize the interstitial ad when the widget is created
    adManager.initInterstitialAd();
    checkFirebaseDatabase();
  }

  // void _startTimer() {
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     setState(() {
  //       Duration difference =
  //           _targetDates[_currentIndex].difference(DateTime.now());
  //       if (difference.inSeconds <= 0) {
  //         _currentIndex = (_currentIndex + 1) % _targetDates.length;
  //         if (_currentIndex == 0) {
  //           timer.cancel(); // Stop the timer when all events finish
  //           _timeUntil = 'All events finished';
  //           return;
  //         }
  //       }
  //       _timeUntil = _formatDuration(difference.abs());
  //     });
  //   });
  // }

//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     int days = duration.inDays;
//     int hours = duration.inHours.remainder(24);
//     int minutes = duration.inMinutes.remainder(60);
//     int seconds = duration.inSeconds.remainder(60);

//    if (days == 0) {
//     if (hours == 0) {
//         if (minutes == 0) {
//             return "තත්පර $seconds";
//         } else {
//             return "මිනිත්තු $minutes තත්පර $seconds";
//         }
//     } else {
//         return "පැය $hours මිනිත්තු $minutes තත්පර $seconds";
//     }
// } else {
//     return "දින $days පැය $hours මිනිත්තු $minutes තත්පර $seconds";
// }
//   }

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
        FirebaseDatabase.instance.ref().child('happy_new_year');

    // Use 'onValue' instead of 'once' to receive a continuous stream of events
    databaseReference
        .child('show_timecount')
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        bool firebaseBoolValue = event.snapshot.value as bool;

        // Update the UI based on the boolean value
        setState(() {
          showTimeCount = firebaseBoolValue;
          print('Firebase database value: $firebaseBoolValue');
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
                    // review.requestReview(context);
                  }),
              SpeedDialChild(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  child: Icon(Icons.compass_calibration),
                  label: 'මාලිමාව',
                  labelStyle: GoogleFonts.notoSerifSinhala(),
                  onTap: () {
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(builder: (context) => Compass()),
                    // );
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

            // ඉමේජ් සලිඩය්
            Column(
              children: [
                if (!showTimeCount) // Show image slider when showTimeCount is false
                  Container(
                    color: Colors.white,
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              height: 100,
                              autoPlayCurve: Curves.fastOutSlowIn,
                              autoPlayAnimationDuration:
                                  Duration(milliseconds: 800),
                              autoPlayInterval: Duration(seconds: 15),
                              enlargeCenterPage: true,
                              aspectRatio: 2.0,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  myCurrentIndex = index;
                                });
                              },
                            ),
                            items: myItems.map((item) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: item,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!showTimeCount) // Show indicator when showTimeCount is false
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedSmoothIndicator(
                      activeIndex: myCurrentIndex,
                      count: myItems.length,
                      effect: WormEffect(
                        dotHeight: 4,
                        dotWidth: 4,
                        spacing: 10,
                        dotColor: Colors.grey.shade200,
                        activeDotColor: Color.fromARGB(255, 255, 153, 0),
                        paintStyle: PaintingStyle.fill,
                      ),
                    ),
                  ),
                // if (showTimeCount) // Show countdown when showTimeCount is true
                //   Container(
                //     width: double.infinity,
                //     height: 150,
                //     color: const Color.fromARGB(255, 255, 255, 255),
                //     child: Padding(
                //       padding:
                //           const EdgeInsets.only(top: 50, left: 25, right: 25),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "අලුත් අවුරුදු ලඟම නැකත",
                //             style: GoogleFonts.notoSerifSinhala(
                //               fontSize: 16,
                //               color: Color.fromARGB(255, 255, 187, 0),
                //             ),
                //             textAlign: TextAlign.start,
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               Navigator.of(context).push(
                //                 MaterialPageRoute(
                //                     builder: (context) => NakathSittuwa()),
                //               );
                //             },
                //             child: Center(
                //               child: Container(
                //                 width: double.infinity,
                //                 decoration: BoxDecoration(
                //                   border: Border.all(
                //                     color: Color.fromARGB(255, 207, 207, 207),
                //                     width: 2.0,
                //                   ),
                //                   borderRadius: BorderRadius.circular(10.0),
                //                 ),
                //                 child: Padding(
                //                   padding: const EdgeInsets.all(8.0),
                //                   child: Column(
                //                     children: [
                //                       Text(
                //                         getEventName(_currentIndex),
                //                         style: GoogleFonts.notoSerifSinhala(
                //                           fontSize: 10,
                //                         ),
                //                       ),
                //                       SizedBox(
                //                         height: 10,
                //                       ),
                //                       Text(
                //                         "$_timeUntil",
                //                         style: GoogleFonts.notoSerifSinhala(),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   ),
              ],
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
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return Menu();
                              //     },
                              //   ),
                              // );
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('දෝශයයි'),
                                    content: Text(
                                        'මෙම සේවාව තාවකාලිකව විසන්දි කර ඇත.'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
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
