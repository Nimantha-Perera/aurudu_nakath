import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RaahuKaalaya extends StatefulWidget {
  const RaahuKaalaya({Key? key}) : super(key: key);

  @override
  _RaahuKaalayaState createState() => _RaahuKaalayaState();
}

class _RaahuKaalayaState extends State<RaahuKaalaya> {
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();



   @override
  void initState() {
    super.initState();
  
    interstitialAdManager.initInterstitialAd();
  
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BackButtonUtil.handleBackButton(interstitialAdManager!);

        return true; // Return true to allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF6D003B),
          centerTitle: true,
          title: Text(
            'රාහු කාලය',
            style: GoogleFonts.notoSerifSinhala(
              fontSize: 15,
            ),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: _rashi_aya_waya(),
        ),
      ),
    );
  }
}

Widget _rashi_aya_waya() {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: StreamBuilder<DatabaseEvent>(
      stream:
          FirebaseDatabase.instance.reference().child('raahu_kalaya').onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red)),
          );
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

        final rows = data != null
            ? data.entries.map((entry) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(
                        entry.value['dawasa']?.toString() ?? '',
                        style: GoogleFonts.notoSansSinhala(
                          fontSize: 12,
                          color: Colors.white
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        entry.value['welawa']?.toString() ?? '',
                       style: GoogleFonts.notoSansSinhala(
                          fontSize: 12,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                );
              }).toList()
            : <DataRow>[];

        double screenWidth = MediaQuery.of(context).size.width;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor:
                MaterialStateColor.resolveWith((states) => Colors.amber),
            columns: [
              DataColumn(
                label: Container(
                  width: screenWidth *
                      0.5, // Set the width as a fraction of the screen width
                  child: Text(
                    'දවස',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              DataColumn(
                label: Container(
                  width: screenWidth *
                      0.5, // Set the width as a fraction of the screen width
                  child: Text(
                    'වේලාව',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
            rows: rows,
          ),
        );
      },
    ),
  );
}
