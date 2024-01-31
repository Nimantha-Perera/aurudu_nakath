import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdManager {
  InterstitialAd? interstitialAd;
  bool isAdLoading = false; // Track ongoing loading requests

  Future<void> initInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: "ca-app-pub-7834397003941676/7162644845", // Replace with your real ad unit ID
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            interstitialAd = ad;
            isAdLoading = false; // Ad loaded successfully
          },
          onAdFailedToLoad: (error) {
            print('InterstitialAd failed to load: $error');
            interstitialAd = null;
            isAdLoading = false; // Reset loading state
            // Consider retrying or displaying a placeholder
          },
        ),
      );
    } catch (e) {
      print('Error initializing interstitialAd: $e');
    }
  }

  void showInterstitialAd() {
    if (interstitialAd != null) {
      interstitialAd!.show();
      _loadNextAd(); // Load the next ad immediately
    } else if (!isAdLoading) {
      _loadNextAd(); // Start loading a new ad if not already loading
    } else {
      print('InterstitialAd not ready yet.');
    }
  }

  void _loadNextAd() {
    isAdLoading = true; // Mark as loading
    initInterstitialAd();
  }
}
