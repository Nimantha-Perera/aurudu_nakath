import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

class ReviewProvider with ChangeNotifier {
  final InAppReview _inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    try {
      final isAvailable = await _inAppReview.isAvailable();
      if (isAvailable) {
        await _inAppReview.requestReview();
      } else {
        // Redirect to Play Store
        const url = 'https://play.google.com/store/apps/details?id=com.nakath.aurudu_nakath'; // Replace with your app's package name
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      }
    } catch (e) {
      print("Error requesting review: $e");
    }
  }
}
