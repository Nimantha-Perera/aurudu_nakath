import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;

  bool _isSubscribed = false;
  bool _available = true;
  ProductDetails? _product;
  bool _purchaseSuccess = false;
  bool _restoredPurchase = false;

  bool get isSubscribed => _isSubscribed;
  ProductDetails? get product => _product;
  bool get purchaseSuccess => _purchaseSuccess;
  bool get restoredPurchase => _restoredPurchase;

  // Callbacks for dialog and navigation
  void Function()? onPurchaseSuccess;
  void Function()? onPurchaseError;

  SubscriptionProvider() {
    _initializeStore();
    _iap.purchaseStream.listen((purchases) {
      _listenToPurchaseUpdates(purchases);
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
      _iap.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  void _listenToPurchaseUpdates(List<PurchaseDetails> purchases) async {
    for (PurchaseDetails purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _isSubscribed = true;
        _purchaseSuccess = true;
        notifyListeners();
        if (onPurchaseSuccess != null) {
          onPurchaseSuccess!();
        }
      } else if (purchase.status == PurchaseStatus.error) {
        print('Purchase error: ${purchase.error}');
        if (onPurchaseError != null) {
          onPurchaseError!();
        }
      } else if (purchase.status == PurchaseStatus.restored) {
        _isSubscribed = true;
        _restoredPurchase = true;
        notifyListeners();
        if (onPurchaseSuccess != null) {
          onPurchaseSuccess!();
        }
      }
    }
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
}