// // review.dart

// import 'package:flutter/material.dart';
// import 'package:in_app_review/in_app_review.dart';

// class Review {
//   InAppReview inAppReview = InAppReview.instance;

//   Future<void> requestReview(BuildContext context) async {

// // 
//     try {
//       if (await inAppReview.isAvailable()) {
//         await inAppReview.requestReview();
//       } else {
//        inAppReview.openStoreListing(appStoreId: 'com.nakath.aurudu_nakath');
//       }
//     } catch (e) {
//       print('Failed to launch review flow: $e');
//     }
//   }
// }
