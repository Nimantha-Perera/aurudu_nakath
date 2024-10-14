import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'usecase/saveuser_details_firstore.dart';

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isSubscribed = false;
  bool _available = true;
  ProductDetails? _product;
  bool _purchaseSuccess = false;
  bool _restoredPurchase = false;
  Timestamp _subcribe_time = Timestamp.fromDate(DateTime.now());

  bool get isSubscribed => _isSubscribed;
  ProductDetails? get product => _product;
  bool get purchaseSuccess => _purchaseSuccess;
  bool get restoredPurchase => _restoredPurchase;
  UserService userService = UserService();

  // Callbacks for dialog and navigation
  void Function()? onPurchaseSuccess;
  void Function()? onPurchaseError;

  SubscriptionProvider() {
    _initializeStore();
    _subscription = _iap.purchaseStream.listen((purchases) {
      _listenToPurchases(purchases);
    });
  }

  Future<void> _initializeStore() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      _available = false;
      notifyListeners();
      return;
    }

    final Set<String> _kIds = {'hela_gpt_pro_monthly_650'};
    final ProductDetailsResponse response = await _iap.queryProductDetails(_kIds);

    if (response.notFoundIDs.isNotEmpty) {
      print('Product not found: ${response.notFoundIDs}');
      return;
    }

    if (response.productDetails.isNotEmpty) {
      _product = response.productDetails.first;
      notifyListeners();
    }

    // Restore any previous purchases
    _restorePurchases();
  }

  void buySubscription() {
    if (_product != null) {
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: _product!);
      print('Attempting to buy: ${_product!.id}'); // Debug statement
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      print('No product available for purchase.');
    }
  }

  Future<void> loadSubscriptionStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isSubscribed = prefs.getBool('isSubscribed') ?? false; // Load subscription status
    print('Loaded subscription status: $_isSubscribed');
    notifyListeners(); // Update listeners with the status
  }

  Future<void> _saveSubscriptionStatus(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSubscribed', status);
    print('Saved subscription status: $status');
  }

  Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      print('Error restoring purchases: $e');
    }
  }

  String get formattedPrice {
    if (_product == null) return '';
    return _product!.price; // This already includes currency symbol
  }

  String get subscriptionDetails {
    if (_product == null) return '';
    return '${_product!.title}\n${_product!.description}\n$formattedPrice/month';
  }

  Future<void> _listenToPurchases(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchase in purchaseDetailsList) {
      print('Purchase Status: ${purchase.status}'); // Check status
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        print('User is subscribed');
        await userService.saveUserDetails(true, _subcribe_time); // Call with true if the user is subscribed
        _updateSubscriptionStatus(true);
        _restoredPurchase = purchase.status == PurchaseStatus.restored;
        onPurchaseSuccess?.call(); // Call the success callback if set
      } else if (purchase.status == PurchaseStatus.canceled) {
        print('User canceled the subscription');
       
        await userService.updateSubscriptionStatus(false);
      } else if (purchase.status == PurchaseStatus.error) {
        print('Error with purchase: ${purchase.error}');
        onPurchaseError?.call(); // Call the error callback if set
      }
    }

    // If no purchase details were received, reset subscription status
    if (purchaseDetailsList.isEmpty) {
      print('No purchase details available.');
      _updateSubscriptionStatus(false);
      await userService.updateSubscriptionStatus(false); // Call with true if the user is subscribed
    }
  }

  Future<void> _updateSubscriptionStatus(bool status) async {
    _isSubscribed = status;
    await _saveSubscriptionStatus(status);
    notifyListeners(); // Notify listeners of the updated status
  }

  @override
  void dispose() {
    _subscription.cancel(); // Cancel the stream when the provider is disposed
    super.dispose();
  }
}
