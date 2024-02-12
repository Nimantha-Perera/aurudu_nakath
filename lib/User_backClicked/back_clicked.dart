import 'package:aurudu_nakath/Ads/init_ads.dart';

class BackButtonUtil {
  static void handleBackButton(InterstitialAdManager interstitialAdManager) {
    print("User clicked back button");
    
    // Check if the interstitial ad is loaded
    if (interstitialAdManager.isInterstitialAdLoaded()) {
      // Show the interstitial ad
      interstitialAdManager.showInterstitialAd();
    } else {
      // Additional logic you want to perform on back button click
      performAdditionalLogic();
    }
  }

  static void performAdditionalLogic() {
    // Additional logic you want to perform on back button click
    print("Performing additional logic on back button click");
  }
}
