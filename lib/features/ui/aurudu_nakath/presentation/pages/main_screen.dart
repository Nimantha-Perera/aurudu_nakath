import 'package:aurudu_nakath/features/ui/Review/review_provider.dart';
import 'package:aurudu_nakath/features/ui/aurudu_nakath/data/repostories/nakath_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'nakath_timer_manager.dart'; // Import the NakathTimerManager

class AuruduNakath extends StatefulWidget {
  const AuruduNakath({Key? key}) : super(key: key);

  @override
  _AuruduNakathState createState() => _AuruduNakathState();
}

class _AuruduNakathState extends State<AuruduNakath> {
  late NakathTimerManager timerManager;
  // String countdownText1 = 'ගනනය කරමින්...';
  // String countdownText2 = 'ගනනය කරමින්...';

  @override
  void initState() {
    super.initState();
     Provider.of<ReviewProvider>(context, listen: false).requestReview();
    timerManager = NakathTimerManager(updateCountdown); // Initialize timer manager
  }

  @override
  void dispose() {
    timerManager.dispose(); // Cancel the timer when disposing
    super.dispose();
  }

  void updateCountdown() {
    setState(() {
      // Update countdown texts using the timer manager
      // countdownText1 = timerManager.getCountdownText(
      //     timerManager.getDifference(timerManager.futureDate1));
      // countdownText2 = timerManager.getCountdownText(
      //     timerManager.getDifference(timerManager.futureDate2));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        
        title: Text(
          "අලුත් අවුරුදු නැකැත්",
          style: GoogleFonts.notoSerifSinhala(fontSize: 14.0, color: Colors.white),
        ),
        backgroundColor: AppBarTheme.of(context).backgroundColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        // color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            // _buildCountdownCard('අලුත් අවුරුදු උදාව සඳහා තව', countdownText2), // Countdown using the updated timer logic
            Expanded(child: NakathData()), // Use the separated NakathData widget
          ],
        ),
      ),
    );
  }

  Widget _buildCountdownCard(String title, String countdown) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.amber,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: GoogleFonts.notoSerifSinhala(fontSize: 14),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
          subtitle: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                countdown,
                style: GoogleFonts.notoSerifSinhala(fontSize: 13),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
