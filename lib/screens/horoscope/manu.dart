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
      _inAppPurchase.purchaseStream.listen((List<PurchaseDetails> purchaseDetailsList) {
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
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color(0xFF6D003B),
        centerTitle: true,
      ),
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
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Your payment message here...',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    // Call the method to initiate the in-app purchase
                                    _initiateInAppPurchase();
                                  },
                                  child: Text('Proceed to Payment'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog box
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Your button text here',
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
                        'Your second button text here',
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
    ProductDetailsResponse productDetails = await _inAppPurchase.queryProductDetails({'welawan_balima'});

    if (productDetails.notFoundIDs.isNotEmpty) {
      // Handle case where product details are not found
      print('Product details not found.');
      return;
    }

    // Example: Make the purchase
    PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails.productDetails.first);
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
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // Placeholder for handling invalid purchase logic
    print('Invalid purchase. Handle accordingly.');
  }
}
