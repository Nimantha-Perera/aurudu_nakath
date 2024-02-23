import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

var name;
var details;
var image;

class ResultsWelaawa extends StatefulWidget {
  final String data;

  const ResultsWelaawa({Key? key, required this.data}) : super(key: key);

  @override
  State<ResultsWelaawa> createState() => _ResultsWelaawaState();
}

class _ResultsWelaawaState extends State<ResultsWelaawa> {
  bool DataIstAvailble = false;
  String firestoreResponse = "Loading...";

  @override
  void initState() {
    super.initState();
    matchDataWithFirestore();
  }

  Future<void> matchDataWithFirestore() async {
    FirebaseFirestore.instance
        .collection('nakath_welawa_results')
        .doc(widget.data)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>>? documentSnapshot) {
      if (documentSnapshot?.exists ?? false) {
        var data = documentSnapshot?.data();

        name = data?['name'] as String?;
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
            firestoreResponse = "ඔබගේ වේලාව නිර්මාණය වෙමින් පවතී";
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
            },
          ),
        ],
        title: Text(
          'ඔබගේ නැකැත් විස්තරය',
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
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Add your desired border radius
                      color: Color.fromARGB(255, 255, 238,
                          0), // Add your desired background color
                    ),
                    padding: EdgeInsets.all(8.0), // Add your desired padding
                    child: Text(
                      name ??
                          '', // Display the name if available, otherwise an empty string
                      style: GoogleFonts.notoSerifSinhala(
                        // Add any additional styling here, such as fontSize, fontWeight, etc.
                        color: const Color.fromARGB(
                            255, 88, 88, 88), // Add your desired text color
                      ),
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
                              child: Image.network(image!),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              child: Image.network(image!),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                if (DataIstAvailble == false)
                  Column(
                    children: [
                      Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              details ?? '',
                              style: GoogleFonts.notoSerifSinhala(),
                            ),
                          ))),
                    ],
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
                            Text(firestoreResponse ?? "",style: GoogleFonts.notoSerifSinhala(),),
                            
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
}
