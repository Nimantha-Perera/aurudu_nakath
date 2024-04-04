import 'dart:async';

class Times {
  static void startMoonTimer() {
    // Second timer to watch the moon
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // You can implement moon watching logic here
      print("Watching the moon...");
    });
  }

  static void startWashingTimer() {
    // Timer to remind washing
    Timer(Duration(minutes: 30), () {
      // You can implement washing reminder logic here
      print("Time to wash your hands!");
    });
  }

  // Add more functions for other activities as needed
}