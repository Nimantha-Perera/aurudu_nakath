import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LagnaPalapala extends StatefulWidget {
  const LagnaPalapala({Key? key}) : super(key: key);

  @override
  _LagnaPalapalaState createState() => _LagnaPalapalaState();
}

class _LagnaPalapalaState extends State<LagnaPalapala> {
  InterstitialAdManager interstitialAdManager = InterstitialAdManager();



   @override
  void initState() {
    super.initState();
    ImageUtils.precacheImage(context);
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
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF6D003B),
          title: Text('ලග්න පලාඵල', style: GoogleFonts.notoSerifSinhala(fontSize: 14)),
        ),
        body: StreamBuilder<DatabaseEvent>(
          stream: FirebaseDatabase.instance.ref().child('lagna_palapala').onValue,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
    
            if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
              return Center(child: CircularProgressIndicator()); // Center the progress indicator
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
                final entry = filteredList[index];
                final title = entry.value['name'];
                final subtitle = entry.value['message'];
                final aya = entry.value['aya'];
                final waya = entry.value['waya'];
                final img = entry.value['imageUrl'];
                final colorString = entry.value['color'];
    
    
    
                final hexColor = colorString.startsWith("#") ? colorString.substring(1) : colorString;
                final colorValue = int.parse('FF' + hexColor, radix: 16); // Simplified color parsing
    
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.black38,
                              backgroundImage: NetworkImage(img),
                            ),
                            title: Text(
                              title,
                              style: GoogleFonts.notoSerifSinhala(fontSize: 14, color: Colors.white),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'අය $aya ',
                                  style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                ),
                                Text(
                                  'වැය $waya ',
                                  style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                ),
                                Text(
                                  'වර්ණය ',
                                  style: GoogleFonts.notoSerifSinhala(fontSize: 12, color: Colors.white70),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(colorValue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 30),
                            child: Text(
                              subtitle,
                              style: GoogleFonts.notoSerifSinhala(fontSize: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
