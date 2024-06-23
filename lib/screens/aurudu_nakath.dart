import 'dart:async';

import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';

class Event {
  final String title;
  final Color color;

  Event({required this.title, required this.color});

  @override
  String toString() {
    return 'Event(title: $title, color: $color)';
  }
}

String thana = '';
String palapala = '';
List<Map<dynamic, dynamic>> dataList = [];
int displayedDataCount = 10;

class AuruduNakathScreen extends StatefulWidget {
  @override
  _AuruduNakathScreenState createState() => _AuruduNakathScreenState();
}

class _AuruduNakathScreenState extends State<AuruduNakathScreen> {

   InterstitialAdManager interstitialAdManager = InterstitialAdManager();
  Map<DateTime, List<Event>> events = {
    DateTime(2024, 1, 15): [
      Event(
          title: 'දෙමල තෛයිපෝංගල් දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 1, 25): [
      Event(
          title: 'දුරුතු පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 2, 4): [
      Event(title: 'නිදහස් දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 2, 14): [
      Event(
          title: "ආදරවන්තයින්ගේ දිනය", color: Color.fromARGB(255, 255, 145, 0)),
    ],
    DateTime(2024, 2, 23): [
      Event(
          title: 'නවම් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 3, 8): [
      Event(
          title: 'මහා ශිවරාත්‍රී දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 3, 11): [
      Event(title: 'රාමසාන් ආරම්භය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 3, 24): [
      Event(
          title: 'මැදින් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 3, 29): [
      Event(title: 'මහ සිකුරාදා', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 3, 31): [
      Event(title: 'පාස්කු ඉරිදා', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 4, 11): [
      Event(title: 'රාමසාන් දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 4, 12): [
      Event(
          title: "සිංහල දෙමළ පරණ අවුරුදු දිනය",
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 4, 13): [
      Event(
          title: "සිංහල දෙමළ අලුත් අවුරුදු දිනය",
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 4, 23): [
      Event(
          title: 'බක් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 5, 1): [
      Event(title: 'ලෝක කම්කරු දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 5, 12): [
      Event(
          title: "අම්මාවරුන්ගේ දිනය", color: Color.fromARGB(255, 255, 145, 0)),
    ],
    DateTime(2024, 5, 23): [
      Event(
          title: 'වෙසක් පුර පසලොස්වක පොහෝ දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 5, 24): [
      Event(
          title: 'වෙසල් දිනට පසු දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 6, 16): [
      Event(title: "පිය වරුන්ගේ දිනය", color: Color.fromARGB(255, 255, 145, 0)),
    ],
    DateTime(2024, 6, 17): [
      Event(title: 'හජ්ජි උත්සව දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 6, 21): [
      Event(
          title: 'පොසොන් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 7, 20): [
      Event(
          title: 'ඇසළ පුර පසලොස්වක පොහෝ දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 8, 19): [
      Event(
          title: 'නිකිනි පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 9, 16): [
      Event(
          title: "නබි නායකතුමාගේ උපන් දිනය)",
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 9, 17): [
      Event(
          title: 'බිනර පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 10, 17): [
      Event(
          title: 'වප් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 10, 31): [
      Event(
          title: 'දීපවාලී උත්සව දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 11, 15): [
      Event(
          title: 'ඉල් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 12, 14): [
      Event(
          title: 'උදුවප් පුර පසලොස්වක පෝය දිනය',
          color: Color.fromARGB(255, 255, 238, 0)),
    ],
    DateTime(2024, 12, 25): [
      Event(
          title: 'නත්තල් උත්සව දිනය', color: Color.fromARGB(255, 255, 238, 0)),
    ],
  };



  List<Event> getEventsForDay(DateTime day) {
    // Strip time information for comparison
    final dayWithoutTime = DateTime(day.year, day.month, day.day);

    // Retrieve events for the date without time
    return events.entries
        .where((entry) =>
            DateTime(entry.key.year, entry.key.month, entry.key.day)
                .isAtSameMomentAs(dayWithoutTime))
        .map((entry) => entry.value)
        .expand((events) => events)
        .toList();
  }

  late Future<FirebaseApp> _initialization;
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  // load table database
  final databaseReference = FirebaseDatabase.instance.ref();

//සූනන් ඇඟවැටීමේ පලාපට ලබා ගැනීම

  void fetchDataFromFirebase() {
    databaseReference
        .child('sunan_agawatima')
        .once()
        .then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value != null) {
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

        if (data != null && data.isNotEmpty) {
          // Iterate through all children
          data.forEach((key, values) {
            dataList.add(values);
          });

          // Set the state to trigger a rebuild with the new data
          setState(() {});
        }
      }
    }).catchError((error) {
      print('Error fetching data: $error');
    });
  }

  Widget buildTable() {
  return Column(
    children: [
      Table(
        border: TableBorder.all(
          // Set the color and width of the border
          color: Color.fromARGB(255, 196, 196, 196),
          width: 1.0,
          // Set the border radius
          borderRadius: BorderRadius.circular(20.0),
        ),
        children: [
          TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'ස්ථානය',
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'පලාඵලය',
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          for (int i = 0; i < displayedDataCount && i < dataList.length; i++)
            TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        dataList[i]['thana'] ?? '',
                        style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        dataList[i]['palapala'] ?? '',
                        style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      SizedBox(height: 10),
      ElevatedButton(
        onPressed: _loadMoreData,
        child: Text('තව බලන්න'),
        style: ElevatedButton.styleFrom(

          backgroundColor: Color.fromARGB(255, 255, 238, 0),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    ],
  );
}


  // Local method for loading more data
  void _loadMoreData() {
    setState(() {
      displayedDataCount = (displayedDataCount + 10).clamp(0, dataList.length);
    });
  }

  @override
  void initState() {
    super.initState();
    print("Events: $events");
    fetchDataFromFirebase();
    interstitialAdManager.initInterstitialAd();
    _initialization = Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BackButtonUtil.handleBackButton(interstitialAdManager!);

        return true; // Return true to allow the back navigation
      },
      child: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildAuruduNakathScreen();
          } else {
            return _buildLoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildAuruduNakathScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6D003B),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(
          '2024 ලිත',
          style: GoogleFonts.notoSerifSinhala(
            fontSize: 15,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/background.jpg'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        child: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    return ListView(
      children: <Widget>[
        // niwaadu donayan

        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color:
                          Colors.grey, // Set your desired background color here
                      borderRadius: BorderRadius.circular(20)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            'රජයේ,බැංකු සහ වෙළෙඳ නිවාඩු දිනයන්',
                            style: GoogleFonts.notoSerifSinhala(
                              fontSize: 15,
                              foreground: Paint()..color = Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "රජයේ නිවාඩු දිනයන්",
                        style: GoogleFonts.notoSerifSinhala(
                            fontSize: 10, color: Colors.white),
                      ),
                      SizedBox(
                          width: 6), // Add some space between text and circle
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color.fromARGB(255, 243, 222,
                              33), // Customize the circle color as needed
                        ),
                        // You can add more styling or child widgets here
                      ),
                      SizedBox(width: 16), // Add some space between the circles
                      Text(
                        "අද දවස",
                        style: GoogleFonts.notoSerifSinhala(
                            fontSize: 10, color: Colors.white),
                      ),
                      SizedBox(
                          width: 6), // Add some space between text and circle
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 130, 163,
                              224), // Customize the circle color as needed
                        ),
                        // You can add more styling or child widgets here
                      ),
                      SizedBox(width: 16),
                      // Add some space between the circles
                      Text(
                        "වෙනත්",
                        style: GoogleFonts.notoSerifSinhala(
                            fontSize: 10, color: Colors.white),
                      ),
                      SizedBox(
                          width: 6), // Add some space between text and circle
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromARGB(255, 255, 136,
                              0), // Customize the circle color as needed
                        ),
                        // You can add more styling or child widgets here
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _calendar(),
            ),
          ),
        ),
        // Your existing UI code...

        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey, // Set your desired background color here
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'ශ්‍රී ලංකාවේ නැකැත් සඳහා සම්මත වේලාව',
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 15,
                      foreground: Paint()..color = Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Adding a card at the bottom
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    '${getCurrentTime()}',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
        ),

        // මරු සිටින දිශාව කොටස

        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey, // Set your desired background color here
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'මරු සිටින දිශාව',
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 15,
                      foreground: Paint()..color = Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Adding a card at the bottom
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _buildDataTable(),
            ),
          ),
        ),

// කෝන මාස

        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey, // Set your desired background color here
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    '2024 කෝණ මාස',
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 15,
                      foreground: Paint()..color = Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: _buildDataList(),
            ),
          ),
        ),

        // සූනන් ඇග වැටීම

        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.grey, // Set your desired background color here
                  borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'සූනන් ඇඟවැටීමේ පලාඵල',
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 15,
                      foreground: Paint()..color = Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: buildTable(),
          ),
        ),
      ],
    );
  }

// මරු සිටින දිසාව ලෝඩ්

  Widget _buildDataTable() {
    DatabaseReference reference = FirebaseDatabase.instance.ref();

    return Container(
      padding: EdgeInsets.all(16.0),
      child: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder<DatabaseEvent>(
              stream:
                  reference.child('aurudu_nakath/maru_sitina_disawa').onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data?.snapshot.value == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final data =
                    snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;

                final rows = data != null
                    ? data.entries.map((entry) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(
                                entry.value['dawasa'] ?? '',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            DataCell(
                              Text(
                                entry.value['disawa'] ?? '',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        );
                      }).toList()
                    : <DataRow>[];

                return DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.amber),
                  dataRowHeight: 60.0,
                  columns: [
                    DataColumn(
                      label: Container(
                        width: 120.0,
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
                        width: 120.0,
                        child: Text(
                          'දිශාව',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  rows: rows,
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

// Widget _rashi_aya_waya() {
//   DatabaseReference reference = FirebaseDatabase.instance.reference();

//   return Container(
//     padding: EdgeInsets.all(16.0),
//     child: FutureBuilder(
//       future: Firebase.initializeApp(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           return StreamBuilder<DatabaseEvent>(
//             stream: reference.child('aurudu_nakath/lagna_rashi_aya_waya').onValue,
//             builder: (context, snapshot) {
//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text(
//                     'Error: ${snapshot.error}',
//                     style: TextStyle(color: Colors.red),
//                   ),
//                 );
//               }

//               if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
//                 return Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
//               final rows = data != null
//                   ? data.entries.map((entry) {
//                       return DataRow(
//                         cells: [
//                           DataCell(
//                             Text(
//                               entry.value['lagnaya'] ?? '',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                           DataCell(
//                             Text(
//                               entry.value['aya'] ?? '',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                           DataCell(
//                             Text(
//                               entry.value['waya'] ?? '',
//                               style: TextStyle(fontSize: 12),
//                             ),
//                           ),
//                         ],
//                       );
//                     }).toList()
//                   : <DataRow>[];

//               return DataTable(
//                 headingRowColor: MaterialStateColor.resolveWith((states) => Colors.amber),
//                 dataRowHeight: 60.0,
//                 columns: [
//                   DataColumn(
//                     label: Container(
//                       width: 120.0,
//                       child: Text(
//                         'ලග්නය',
//                         textAlign: TextAlign.start,
//                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       width: 120.0,
//                       child: Text(
//                         'අය',
//                         textAlign: TextAlign.start,
//                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   DataColumn(
//                     label: Container(
//                       width: 120.0,
//                       child: Text(
//                         'වැය',
//                         textAlign: TextAlign.start,
//                         style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//                 rows: rows,
//               );
//             },
//           );
//         } else {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//       },
//     ),
//   );
// }

  Widget _calendar() {
    DateTime? selectedDate;

    return Container(
      child: TableCalendar(
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 12, 31),
        focusedDay: DateTime.now(),

        headerStyle: HeaderStyle(
          decoration: BoxDecoration(),
          titleTextStyle: GoogleFonts.notoSerifSinhala(
            fontSize: 15,
          ),
          formatButtonVisible: false,
          titleCentered: true,
        ),
        daysOfWeekHeight: 50,

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            selectedDate = selectedDay;
          });

          if (selectedDate != null) {
            _showBottomSheet(context, selectedDate!);
          }
        },
        availableGestures: AvailableGestures.all,
        eventLoader: (day) => getEventsForDay(day),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final markers = <Widget>[];

            if (events.isNotEmpty) {
              markers.add(
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: _buildEventsMarkers(
                    events.cast<Event>(), // Explicit cast here
                  ),
                ),
              );
            }

            // Return the first marker or null
            return markers.isNotEmpty ? markers[0] : null;
          },
        ),
        locale: 'si_LK', // Set Sinhala language and Sri Lanka as the country
      ),
    );
  }

  Widget _buildEventsMarkers(List<Event> events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: events.first.color,
      ),
      width: 16.0,
      height: 16.0,
    );
  }

  void _showBottomSheet(BuildContext context, DateTime selectedDate) {
    final selectedDateUtc =
        DateTime.utc(selectedDate.year, selectedDate.month, selectedDate.day);
    final eventsForDay = getEventsForDay(selectedDateUtc);

    print('Events for $selectedDateUtc: $eventsForDay');
    print('Selected Date: $selectedDateUtc');
    print('All Events: $events');
    print('Events for Day: ${getEventsForDay(selectedDateUtc)}');

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
          bottomLeft: Radius.zero,
          bottomRight: Radius.zero,
        ),
      ),
      builder: (context) {
        return Container(
          height: 150.0, // Set the fixed height to 40
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${selectedDateUtc.day}/${selectedDateUtc.month}/${selectedDateUtc.year} දිනය',
                style: GoogleFonts.notoSerifSinhala(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 10.0), // Adjust as needed
              if (eventsForDay.isNotEmpty)
                ...eventsForDay.map((event) {
                  print('Creating ListTile for event: $event');
                  return Container(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
                      title: Center(
                        child: Text(
                          event.title,
                          style: GoogleFonts.notoSerifSinhala(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  );
                })
              else
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Text(
                      'සාමාන්‍ය දිනයකි',
                      style: GoogleFonts.notoSerifSinhala(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = DateFormat('HH:mm:ss').format(now);

    return formattedTime;
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

Widget _buildDataList() {
  List<String> dataArray = [
    'ජනවාරි 01 සිට ජනවාරි 15 දක්වා ධනු රවිය',
    'මාර්තු 14 සිට අප්‍රේල් 13 දක්වා මීන රවිය',
    'ජූනි 15 සිට ජූනි 16 දක්වා මිඨුන රවිය',
    'සැප්තැම්බර් 16 සිට ඔක්තෝම්බර් 17 දක්වා\nකන්‍යා රවිය',
    'දෙසැම්බර් 15 සිට 31 දක්වා ධනු රවිය',
  ];

  return Column(
    children: dataArray
        .map(
          (data) => ListTile(
            title: Center(
              child: Text(
                data,
                style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
        .toList(),
  );
}
