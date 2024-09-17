import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;

  bool _isSubscribed = false;
  bool _available = true;
  ProductDetails? _product;

  bool get isSubscribed => _isSubscribed;
  ProductDetails? get product => _product;

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
        notifyListeners();
        if (onPurchaseSuccess != null) {
          onPurchaseSuccess!();
        }
      }
    }
  }
}
