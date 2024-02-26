import 'dart:async';

import 'package:flutter/material.dart';

class ImageUtils {
  static Future<void> precacheImage([Object? imageProvider]) async {
    final ImageProvider<Object> imageProvider = AssetImage('assets/bg/iPhone SE - 2.png');

    try {
      // Precache the image without passing any arguments
      await precacheImage(imageProvider);  // Corrected line
    } catch (error) {
      print('Error precaching image: $error');
    }
  }
}
