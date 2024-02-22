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
          });
        } else {
          setState(() {
            firestoreResponse = "Your response is not available";
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

 Future<void> _downloadPdf() async {
    final pdf = pdfLib.Document();

    // Provide a custom font with Sinhala support
    final fontData = await rootBundle.load("assets/NotoSerifSinhala-Thin.ttf");
    final sinhalaFont = pdfLib.Font.ttf(fontData);

    // Add content to the PDF
    pdf.addPage(pdfLib.Page(
      build: (context) {
        return pdfLib.Column(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
          children: [
            pdfLib.Text(
              name ?? '',
              style: pdfLib.TextStyle(font: sinhalaFont),
            ),
            if (DataIstAvailble == false &&
                image != null &&
                image.isNotEmpty)
              pdfLib.Row(
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: [
                  pdfLib.Column(
                    children: [
                      pdfLib.Container(
                        width: 150,
                        // child: pdfLib.Image(pdfLib.NetworkImage(image!)),
                      ),
                    ],
                  ),
                  pdfLib.Column(
                    children: [
                      pdfLib.Container(
                        width: 150,
                        // child: pdfLib.Image(pdfLib.NetworkImage(image!)),
                      ),
                    ],
                  )
                ],
              ),
            pdfLib.Text(
              details ?? '',
              style: pdfLib.TextStyle(font: sinhalaFont),
            ),
          ],
        );
      },
    ));

    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/your_welawa_result.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF using the default viewer
    Process.run('open', [file.path]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadPdf();
            },
          ),
        ],
        title: Text(
          'Your Welawa',
        ),
        backgroundColor: Colors.green[400],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(name ?? ''),
                ),
                if (DataIstAvailble == false &&
                    image != null &&
                    image.isNotEmpty)
                  Row(
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
                Text(details ?? ''),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
