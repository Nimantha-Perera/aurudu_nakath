import 'package:aurudu_nakath/screens/horoscope/form_welawa/form_welawa.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void initState() {
    super.initState();
    // Initialize in-app purchases
    _initInAppPurchases();
  }

  void _initInAppPurchases() async {
    // Check if in-app purchases are available
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (isAvailable) {
      // Listen to purchase updates
      _inAppPurchase.purchaseStream
          .listen((List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      });

      // Additional setup or product loading can be done here
    } else {
      // Handle case where in-app purchases are not available on this device
      print('In-app purchases are not available.');
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
                                    margin: EdgeInsets.only(top: 50),
                                    child: Text(
                                      'මෙම සේවාව සඳහා රු 1500/= ක මුදලක් අයකෙරේ. එය ඔබට පහතින් (ක්‍රෙඩිට්/ඩෙබිට් කාඩ්පත් මගින්) ගෙවිය හැක.',
                                      style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14, color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Image.asset(
                                    'assets/bulath_kolaya.png',
                                    width: 150, // Set the desired width here
                                  ),

                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.green),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              10.0), // Set your desired border radius
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Call the method to initiate the in-app purchase
                                      _initiateInAppPurchase();
                                    },
                                    child: Text(
                                      'ගෙවීම සමඟ ඉදිරියට යන්න',
                                      style: GoogleFonts.notoSerifSinhala(
                                          fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actions: [], // Empty actions to make room for close icon
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
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
                        borderRadius: BorderRadius.circular(20),
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
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
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
                        borderRadius: BorderRadius.circular(20),
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
  void _initiateInAppPurchase() async {
    // Example: Load product details from your backend or use a predefined product ID
    ProductDetailsResponse productDetails =
        await _inAppPurchase.queryProductDetails({'welawan_balima'}.toSet());

    if (productDetails.notFoundIDs.isNotEmpty) {
      // Handle case where product details are not found
      print('Product details not found.');
      return;
    }

    // Example: Make the purchase
    PurchaseParam purchaseParam =
        PurchaseParam(productDetails: productDetails.productDetails.first);
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Handle pending status
        print('Purchase is pending.');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          // Handle purchase error
          print('Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          // Handle successful purchase or restore
          bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            _deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // Placeholder for purchase verification logic
    return true;
  }

  void _deliverProduct(PurchaseDetails purchaseDetails) {
    // Placeholder for product delivery logic
    print('Product delivered successfully.');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return Form_Welaawa();
        },
      ),
    );
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // Placeholder for handling invalid purchase logic
    print('Invalid purchase. Handle accordingly.');
  }
}
