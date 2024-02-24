import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';

import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

var name;
var name2;
var details;
var image;

class ResultsPorondam extends StatefulWidget {
  final String data;

  const ResultsPorondam({Key? key, required this.data}) : super(key: key);

  @override
  State<ResultsPorondam> createState() => _ResultsWelaawaState();
}

class _ResultsWelaawaState extends State<ResultsPorondam> {
  bool DataIstAvailble = false;
  String firestoreResponse = "Loading...";

  @override
  void initState() {
    super.initState();
    matchDataWithFirestore();
  }

  Future<void> matchDataWithFirestore() async {
    FirebaseFirestore.instance
        .collection('nakath_porondam_results')
        .doc(widget.data)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) {
      if (documentSnapshot?.exists ?? false) {
        var data = documentSnapshot?.data();

        name = data?['name'] as String?;
        name2 = data?['name2'] as String?;
        details = data?['details'] as String?;
        image = data?['image'] as String?;

        if (name != null && name.isNotEmpty ||
            details != null && details.isNotEmpty) {
          setState(() {
            firestoreResponse =
                "Your response for matching Document ID from Firestore. Codes:";
            DataIstAvailble = false;
            print("sfdsf  $name");
          });
        } else {
          setState(() {
            firestoreResponse = "ඔබගේ පොරොන්දම සැකසෙමින් වෙමින් පවතී";
            DataIstAvailble = true;
          });
        }
      } else {
        setState(() {
          firestoreResponse = "Your welawa does not have matching codes.";
        });
      }
    });
  }

  Future<void> downloadImage() async {
    try {
      // Show a loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Downloading PDF"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // CircularProgressIndicator(
                //   strokeWidth: 6,
                //   valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                //   semanticsLabel: 'Downloading',
                // ),
                // SizedBox(height: 16), // Adjust the spacing between the circular and linear progress indicators
                LinearProgressIndicator(
                  value: 0.5, // Set the value accordingly (between 0.0 and 1.0)
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.green), // Adjust the color if needed
                  semanticsLabel:
                      'Progress', // Optional label for accessibility
                ),
              ],
            ),
          );
        },
      );

      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('porondam_pdf/${widget.data}.pdf');
      final String url = await ref.getDownloadURL();

      // Use the URL to download the image file using http package
      final http.Response response = await http.get(Uri.parse(url));

      // Get the downloads directory
      final downloadsDirectory = await getDownloadsDirectory();
// Access files in the Downloads directory

      // Save the file to the downloads directory
      final String localFilePath =
          '${downloadsDirectory?.path}/nakath_app_porondam.pdf';
      final File localFile = File(localFilePath);

      await localFile.writeAsBytes(response.bodyBytes);

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show success dialog
      // showDialog(
      //   context: context,
      //   builder: (BuildContext context) {
      //     return AlertDialog(
      //       title: Text("Download Complete"),
      //       content: Text("Image downloaded successfully. Saved to: $localFilePath"),
      //       actions: <Widget>[
      //         TextButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           child: Text("OK"),
      //         ),
      //       ],
      //     );
      //   },
      // );
      Fluttertoast.showToast(
          msg: "Saved to: $localFilePath",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      print('Image Download URL: $url');
    } catch (e) {
      print('Error downloading image: $e');
      // Handle errors accordingly

      // Close the loading dialog
      Navigator.of(context).pop();

      // Show error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("සමාවන්න, ඔබගේ PDF ගොනුව සැකසෙමින් පවතී."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _refresh() async {
    await matchDataWithFirestore();
  }

  Future<pdfLib.Image> _loadImageFromNetwork(String imageUrl) async {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      final assetBundle = NetworkAssetBundle(Uri.parse(imageUrl));
      final bytes = (await assetBundle.load(imageUrl)).buffer.asUint8List();
      return pdfLib.Image(pdfLib.MemoryImage(bytes));
    } else {
      // Handle the case when the image URL is not available
      return pdfLib.Image(pdfLib.MemoryImage(Uint8List(0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              // generatePDF();
              downloadImage();
            },
          ),
        ],
        title: Text(
          'ඔබගේ පොරොන්දම් විස්තරය',
          style: GoogleFonts.notoSerifSinhala(fontSize: 15),
        ),
        backgroundColor: Color(0xFF6D003B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (DataIstAvailble == false)
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Image.asset(
                          'assets/monn_sun/sun.png',
                          width: 100, // Replace with your image path
                        ),
                        Image.asset(
                          'assets/monn_sun/moon.png',
                          width: 100,
                        )
                      ],
                    ),
                  ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        8.0), // Add your desired border radius
                    color: Color.fromARGB(255, 255, 255,
                        255), // Add your desired background color
                  ),
                  padding: EdgeInsets.all(8.0), // Add your desired padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              name ??
                                  '', // Display the name if available, otherwise an empty string

                              style: GoogleFonts.notoSerifSinhala(
                                fontSize: 12,
                                // Add any additional styling here, such as fontSize, fontWeight, etc.
                                color: const Color.fromARGB(255, 88, 88,
                                    88), // Add your desired text color
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Text(
                              name2 ??
                                  '', // Display the name if available, otherwise an empty string

                              style: GoogleFonts.notoSerifSinhala(
                                fontSize: 12,
                                // Add any additional styling here, such as fontSize, fontWeight, etc.
                                color: const Color.fromARGB(255, 88, 88,
                                    88), // Add your desired text color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (DataIstAvailble == false &&
                    image != null &&
                    image.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/nakath-af5a0.appspot.com/o/Welawa_images%2Fcxc.png?alt=media&token=d5a9f052-20ab-4833-9501-c472156223a7"),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/nakath-af5a0.appspot.com/o/Welawa_images%2Fcxc.png?alt=media&token=d5a9f052-20ab-4833-9501-c472156223a7"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                if (DataIstAvailble == false)
                  Container(
                    margin: EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "උපන් දිනය 1996.07.10",
                          style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                        ),
                        Text(
                          "උපන් දිනය 1996.02.10",
                          style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Table(
                    border: TableBorder.all(),
                    columnWidths: const <int, TableColumnWidth>{
                      0: FixedColumnWidth(85.0),
                      1: FixedColumnWidth(85.0),
                      2: FixedColumnWidth(85.0),
                      3: FixedColumnWidth(85.0),
                    },
                    children: _buildRows(),
                  ),
                ),
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10, bottom: 10),
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // details ?? '',
                            "ඔබගේ පොරොන්දම 78% නිවැරදිව ගැලපේ",
                            style: GoogleFonts.notoSerifSinhala(),
                          ),
                        ))),
                  ],
                ),
                Center(
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "මෙම පොරොන්දම් ගැලපීම සංස්තෘත මූලධර්ම වලට අනුව නිර්මාණය කර ඇත",
                      style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                    ),
                  ),
                ),
                if (DataIstAvailble == true)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // Aligns the text in the center vertically
                          children: [
                            Lottie.network(
                              'https://lottie.host/ed28ecd2-c979-49ad-a858-13d14f04b651/QGSI90WORA.json',
                              height: 200,
                              width: 200,
                            ),
                            Text(
                              firestoreResponse ?? "",
                              style: GoogleFonts.notoSerifSinhala(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<TableRow> _buildRows() {
    List<TableRow> rows = [];

    // Adding column header row
    rows.add(
      TableRow(
        children: [
          TableCell(
            child: Container(
              height: 40.0, // Adjust the height as needed
              padding: EdgeInsets.all(8.0),
              color: Colors.blue,
              child: Center(
                child: Text(
                  'පොරොන්දම',
                  style: GoogleFonts.notoSerifSinhala(
                    color: Colors.white,
                    fontSize: 12.0, // Adjust the font size as needed
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.all(8.0),
              color: Colors.green,
              child: Center(
                child: Text(
                  'ස්ත්‍රී',
                  style: GoogleFonts.notoSerifSinhala(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.all(8.0),
              color: Colors.orange,
              child: Center(
                child: Text(
                  'පුරුශ',
                  style: GoogleFonts.notoSerifSinhala(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          TableCell(
            child: Container(
              height: 40.0,
              padding: EdgeInsets.all(8.0),
              color: Colors.red,
              child: Center(
                child: Text(
                  'ප්‍රතිඵලය',
                  style: GoogleFonts.notoSerifSinhala(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // Adding data rows
    for (int i = 0; i < 20; i++) {
      rows.add(
        TableRow(
          children: [
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('Row $i, Col 0'),
              ),
            ),
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('Row $i, Col 1'),
              ),
            ),
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('Row $i, Col 2'),
              ),
            ),
            TableCell(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text('Row $i, Col 3'),
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }
}
