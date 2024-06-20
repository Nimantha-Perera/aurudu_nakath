import 'dart:async';

import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NakathSittuwa extends StatefulWidget {
  const NakathSittuwa({Key? key}) : super(key: key);

  @override
  _NakathSittuwaState createState() => _NakathSittuwaState();
}

class _NakathSittuwaState extends State<NakathSittuwa> {

  InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  late DateTime futureDate;
  late Timer timer;

  late DateTime futureDate1;
  late DateTime futureDate2;

  @override
  void initState() {
    super.initState();
    interstitialAdManager.initInterstitialAd();
    countdownText1 = 'ගනනය කරමින්...';
    countdownText2 = 'ගනනය කරමින්...';
     ImageUtils.precacheImage(context);

    // Future dates
    futureDate1 = DateTime(2024, 4, 11);
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

  late String countdownText1;
  late String countdownText2;

  @override
  void dispose() {
    // Dispose of the timer to prevent memory leaks
    timer.cancel();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
       BackButtonUtil.handleBackButton(interstitialAdManager);
        return true; // Return true to allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          foregroundColor: Colors.white,
           iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color(0xFF6D003B),
          title: Text("අලුත් අවුරුදු නැකැත්",style: GoogleFonts.notoSerifSinhala(
                fontSize: 14.0,
                color: Colors.white,
              ),),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
             
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber,
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'අලුත් අවුරුදු උදාව සඳහා තව',
                                  style: GoogleFonts.notoSerifSinhala(
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                        ],
                      ),
                      subtitle: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$countdownText2',
                            style: GoogleFonts.notoSerifSinhala(
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
    
    
               Expanded(
                child: _NakathData(),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _NakathData() {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('aurudu_nakath_sittuwa')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return Center(
              child:
                  CircularProgressIndicator()); // Center the progress indicator
        }

      final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

// Convert the data to a list and sort it based on the 'index_no' field
          final sortedList = data.entries.toList()
            ..sort((a, b) => b.value['index_no'].compareTo(a.value['index_no']));

// Filter the list to include only items with indices 1 to 10
          final filteredList = sortedList.where((entry) {
            int index = entry.value['index_no'];
            return index >= 1 && index <= 12;
          }).toList();

        return ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
           // Access data efficiently
            final entry = filteredList[index];
            final title = entry.value['nakatha'];
            final subtitle = entry.value['wistharaya'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: GestureDetector(
                  
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.amber),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '$title',
                                style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                    subtitle: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '$subtitle',
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 13,
                        ),
                      ),
                    )),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
