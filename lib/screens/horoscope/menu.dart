import 'package:aurudu_nakath/screens/horoscope/form_welawa/form_welawa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:url_launcher/url_launcher.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  TextEditingController _textFieldController = TextEditingController();
  String _displayText = '';
  @override
  void initState() {
    super.initState();
    // Initialize in-app purchases
    // _initInAppPurchases();
    _getCopiedText();
  }

// Function to retrieve the copied text
  Future<void> _getCopiedText() async {
    ClipboardData? clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _displayText = clipboardData.text!;
        _textFieldController.text = _displayText;
      });
    }
  }

  // Function to paste the number 12344
  void checkFirestoreValue(BuildContext context) async {
    // Specify the actual collection name:
    String collectionName = 'nakath_codes'; // Replace with the actual name
    String fieldName = 'codes'; // Replace with the actual field name

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection(collectionName).get();

      if (querySnapshot.docs.isNotEmpty) {
        bool matchFound = false;
        QueryDocumentSnapshot<Map<String, dynamic>>? matchingDocument;

        for (QueryDocumentSnapshot<Map<String, dynamic>> document
            in querySnapshot.docs) {
          // Check if the "codes" field exists in the document
          if (document.data()!.containsKey(fieldName)) {
            String firestoreValue = document.get(fieldName);

            if (firestoreValue == _displayText) {
              matchFound = true;
              matchingDocument = document;
              break; // Exit the loop if a match is found
            }
          }
        }

        if (matchFound && matchingDocument != null) {
          // Show success SnackBar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('සාර්තකයි'),
            backgroundColor: Color.fromARGB(255, 0, 255, 115),
          ));

          // Delete the field from Firestore
          await FirebaseFirestore.instance
              .collection(collectionName)
              .doc(matchingDocument.id)
              .delete();

          // Navigate to another page
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return FormWelaawa();
              },
            ),
          );
        } else {
          // Show error SnackBar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('ඔබ ඇතුලත්කල අංකය වැරදී'),
            backgroundColor: Color.fromARGB(255, 255, 0, 0),
          ));
        }
      } else {
        print('No documents found in the collection');
      }
    } on FirebaseException catch (e) {
      print('Error fetching data: $e');
      // Handle potential errors gracefully
    }
  }

  // void _initInAppPurchases() async {
  //   // Check if in-app purchases are available
  //   final bool isAvailable = await _inAppPurchase.isAvailable();
  //   if (isAvailable) {
  //     // Listen to purchase updates
  //     _inAppPurchase.purchaseStream
  //         .listen((List<PurchaseDetails> purchaseDetailsList) {
  //       _listenToPurchaseUpdated(purchaseDetailsList);
  //     });

  //     // Additional setup or product loading can be done here
  //   } else {
  //     // Handle case where in-app purchases are not available on this device
  //     print('In-app purchases are not available.');
  //   }
  // }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Menu'),
      //   backgroundColor: Color(0xFF6D003B),
      //   centerTitle: true,
      // ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/bg/iPhone SE - 2.png'),
          fit: BoxFit.cover, // Replace with your image asset path
        )),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.green[400],
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Close icon button at the top
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 30.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    margin: EdgeInsets.only(top: 0),
                                    child: Text(
                                      'මෙම සේවාව සඳහා රු 1500/= ක මුදලක් අයකරන අතර පහත ඇති ගිනුමට මුදල් බැර කර මුදල් ගෙවූ බවට තහවුරු කිරීමට ඔබගේ රිසිට්පත පහතින් ඇති WhatsApp බොත්තම ක්ලික් කර අපට ඉදිරිපත් කරන්න. ලබාදෙන උපදෙස් පිලිපදින්න.',
                                      style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),

                                  SizedBox(width: 15),
                                  Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            "Bank of Ceylon ගෙලිඔය",
                                            style: GoogleFonts.notoSerifSinhala(
                                                fontSize: 13),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "G.W.G Nimantha Madushanka",
                                            style: GoogleFonts.notoSerifSinhala(
                                                fontSize: 13),
                                          ),
                                        ),
                                        Center(
                                          child: Text(
                                            "XXXXXXXX",
                                            style: GoogleFonts.notoSerifSinhala(
                                                fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color.fromARGB(255, 255, 217, 0)),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Call the method to initiate the in-app purchase
                                      _launchURL(
                                          'https://api.whatsapp.com/send?phone=94762938664&text=%E0%B7%84%E0%B7%8F%E0%B6%BA%E0%B7%92%20%E0%B6%B8%E0%B6%B8%20%E0%B6%B1%E0%B7%90%E0%B6%9A%E0%B7%90%E0%B6%AD%E0%B7%8A%20App%20%E0%B6%91%E0%B6%9A%E0%B7%99%E0%B6%B1%E0%B7%8A%20%E0%B6%86%E0%B7%80%E0%B7%99');
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        // Adding some spacing between icon and text
                                        Text(
                                          'WhatsApp මගින්',
                                          style: GoogleFonts.notoSerifSinhala(
                                            fontSize: 10,
                                          ),
                                        ),

                                        SizedBox(width: 8),

                                        Icon(FontAwesomeIcons.whatsapp,
                                            color: Colors.white),
                                      ],
                                    ),
                                  ),

                                  // Done Payment

                                  Text(
                                    'ගෙවීම තහවුරු කල පසු අංකය (Paste) කර ඉදිරියට යන්න',
                                    style: GoogleFonts.notoSerifSinhala(
                                      fontSize: 12,
                                    ),
                                  ),

                                  Divider(
                                    color: const Color.fromARGB(255, 255, 255,
                                        255), // Set the color of the divider
                                    thickness:
                                        1.0, // Set the thickness of the divider
                                    height:
                                        20.0, // Set the height of the divider
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          style: GoogleFonts.notoSerifSinhala(
                                            fontSize: 12,
                                          ),
                                          controller: _textFieldController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: 'අංකය අලවන්න',
                                            border: OutlineInputBorder(),
                                          ),
                                          enabled: false,
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Add spacing between TextField and Button
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 0, 151,
                                              93), // Set your desired background color here
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Optional: You can add border radius for rounded corners
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            // Add your button's functionality here
                                            // For example, you can print a message
                                            print('Button pressed!');
                                            checkFirestoreValue(context);
                                            _getCopiedText();
                                          },
                                          icon: Icon(Icons.paste),
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            actions: [], // Empty actions to make room for close icon
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(19),
                      child: Text(
                        'වෙලාවන් බැලිමට',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: Colors.amber[800],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Add functionality for the second button
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return FormWelaawa();
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(19),
                      child: Text(
                        'පොරොන්දම් ගැලපීමට',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      backgroundColor: Colors.amber[800],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Placeholder method for in-app purchase initiation
  // void _initiateInAppPurchase() async {
  //   // Example: Load product details from your backend or use a predefined product ID
  //   ProductDetailsResponse productDetails =
  //       await _inAppPurchase.queryProductDetails({'nakath_pay'}.toSet());

  //   if (productDetails.notFoundIDs.isNotEmpty) {
  //     // Handle case where product details are not found
  //     print('Product details not found.');
  //     return;
  //   }

  //   // Example: Make the purchase
  //   PurchaseParam purchaseParam =
  //       PurchaseParam(productDetails: productDetails.productDetails.first);
  //   await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  // }

  // void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
  //   purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
  //     if (purchaseDetails.status == PurchaseStatus.pending) {
  //       // Handle pending status
  //       print('Purchase is pending.');
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.error) {
  //         // Handle purchase error
  //         print('Purchase error: ${purchaseDetails.error}');
  //       } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //           purchaseDetails.status == PurchaseStatus.restored) {
  //         // Handle successful purchase or restore
  //         bool valid = await _verifyPurchase(purchaseDetails);
  //         if (valid) {
  //           _deliverProduct(purchaseDetails);
  //         } else {
  //           _handleInvalidPurchase(purchaseDetails);
  //         }
  //       }

  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await _inAppPurchase.completePurchase(purchaseDetails);
  //       }
  //     }
  //   });
  // }

  // Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
  //   // Placeholder for purchase verification logic
  //   return true;
  // }

  // void _deliverProduct(PurchaseDetails purchaseDetails) {
  //   // Placeholder for product delivery logic
  //   print('Product delivered successfully.');
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (context) {
  //         return Form_Welaawa();
  //       },
  //     ),
  //   );
  // }

  // void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
  //   // Placeholder for handling invalid purchase logic
  //   print('Invalid purchase. Handle accordingly.');
  // }

  // check database in number
}
