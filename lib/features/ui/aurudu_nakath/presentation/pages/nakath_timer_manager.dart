// nakath_timer_manager.dart
import 'dart:async';

class NakathTimerManager {
  late DateTime futureDate1;
  late DateTime futureDate2;
  late Timer timer;
  late Function updateUI;

  NakathTimerManager(this.updateUI) {
    futureDate1 = DateTime(2024, 4, 11);
    futureDate2 = DateTime(2024, 4, 13, 21, 5);

    // Start timer
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      updateUI();  // Notify UI to update countdown
    });
  }

  Duration getDifference(DateTime futureDate) {
    return futureDate.difference(DateTime.now());
  }

  String getCountdownText(Duration difference) {
    if (difference.inSeconds <= 0) {
      return 'අලුත් අවුරුදු ලබා අවසන්';
    } else {
      int days = difference.inDays;
      int hours = difference.inHours % 24;
      int minutes = difference.inMinutes % 60;
      int seconds = difference.inSeconds % 60;
      return 'දින: $days  පැය: $hours  මිනිත්තු: $minutes  තත්පර: $seconds';
    }
  }

  void dispose() {
    timer.cancel();
  }
}
