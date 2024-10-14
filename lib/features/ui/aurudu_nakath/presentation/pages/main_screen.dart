import 'package:aurudu_nakath/features/ui/Review/review_provider.dart';
import 'package:aurudu_nakath/features/ui/aurudu_nakath/data/repostories/nakath_data.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';



class AuruduNakath extends StatefulWidget {
  const AuruduNakath({Key? key}) : super(key: key);

  @override
  _AuruduNakathState createState() => _AuruduNakathState();
}

class _AuruduNakathState extends State<AuruduNakath> {

  // String countdownText1 = 'ගනනය කරමින්...';
  // String countdownText2 = 'ගනනය කරමින්...';

  @override
  void initState() {
    super.initState();
     Provider.of<ReviewProvider>(context, listen: false).requestReview();

  }

  @override
  void dispose() {

    super.dispose();
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

 
}
