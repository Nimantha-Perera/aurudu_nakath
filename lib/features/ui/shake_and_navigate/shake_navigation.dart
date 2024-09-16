// shake_navigation.dart
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart'; // Assuming this has AppRoutes

class ShakeNavigation {
  ShakeDetector? _shakeDetector;

  // Constructor that takes the BuildContext for navigation
  ShakeNavigation(BuildContext context) {
    // Initialize the shake detector
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        // Open Bottom Sheet when shake is detected
        _showBottomSheet(context);
      },
    );
  }

  // Method to show Bottom Sheet with a button
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Do you need help?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the help screen on button click
                  Navigator.pushNamed(context, AppRoutes.help);
                },
                child: Text("Go to Help"),
              ),
            ],
          ),
        );
      },
    );
  }

  // Dispose method to stop the shake detector
  void dispose() {
    _shakeDetector?.stopListening();
  }
}
