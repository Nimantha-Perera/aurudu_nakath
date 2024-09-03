import 'dart:async';

// import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:aurudu_nakath/Ads/constombannerad.dart';
import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/Notifications/notification_service.dart';
import 'package:aurudu_nakath/screens/hela_ai.dart';
import 'package:aurudu_nakath/Compass/compass.dart';
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
import 'package:intl/intl.dart';
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
    checkMaintenance(context);
    checkFirebaseDatabase();
  }

 

  //Check Maintainance

  Future<Widget> checkMaintenance(BuildContext context) async {


    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DatabaseReference databaseReference =
        FirebaseDatabase.instance.ref().child('maintenance');

    // Use 'onValue' instead of 'once' to receive a continuous stream of events
    databaseReference
        .child('maintenancebrake')
        .onValue
        .listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> data =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        bool firebaseBoolValue = data['status'] as bool;
        String startDate = data['startDate'] as String;
        String endDate = data['endDate'] as String;

        // Show alert message based on the boolean value
        if (firebaseBoolValue) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('නියමිත නඩත්තු දැනුම්දීම'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text('ප්‍රිය සමාජිකයන්,'),
                      SizedBox(height: 10),
                      Text(
                          'ඔබේ නැකැත් යෙදුමේ කාර්ය සාධන වර්ධනය කිරීම සහ නව අංග සම්බන්ධ කිරීම සඳහා අපි නියමිත නඩත්තු කටයුතු සිදු කරමින් සිටිමු. නඩත්තු කටයුතු පහත දැක්වෙන පරිදි සිදු කෙරේ:'),
                      SizedBox(height: 10),
                      Text('දිනය: $today'),
                      Text('වේලාව: $startDate සිට $endDate දක්වා'),
                      SizedBox(height: 10),
                      Text(
                          'මෙම කාලය තුළ, යෙදුම තාවකාලිකව භාවිතා කළ නොහැකි වනු ඇත. මෙය ඔබට සිදු කරන හැකියාවට අපි කණගාටු වන අතර, ඔබගේ පරිශීලක අත්දැකීම වර්ධනය කිරීම සඳහා අපි කරන මෙය ඔබගේ අවබෝධයට ස්තූතිවන්ත වෙමු.'),
                      SizedBox(height: 10),
                      Text('ඔබගේ අඛණ්ඩ සහය සහ බලාපොරොත්තුවට ස්තූතිවන්ත වේවා.'),
                      SizedBox(height: 10),
                      Text('ඔබගේ,'),
                      Text('නැකැත් App යෙදුම් කණ්ඩායම'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Color.fromARGB(255, 255, 145, 0)),
                    ),
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        // Handle the case where the snapshot is null or doesn't contain data
        print(
            'Firebase database value for maintenancebrake is null or does not contain data');
      }
    });

    // Return a placeholder widget while the value is being fetched
    return Container();
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
       
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                'assets/bg/iPhone SE - 2.png',
                fit: BoxFit.cover,
              ),
            ),
           
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

                                Navigator.of(context)
                                    .pushNamed('/nakath_sittuwa');
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
                                Navigator.of(context).pushNamed('/litha');
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
                              Navigator.of(context).pushNamed('/lagna');
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
                              Navigator.of(context).pushNamed('/rahu_kalayana');
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
                              Navigator.of(context).pushNamed('/helaai');
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

                              Navigator.of(context).pushNamed('/tools');
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
                                          'වෙනත් මෙවලම්',
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
