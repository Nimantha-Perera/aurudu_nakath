import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class MaintenanceScreenDialog extends StatelessWidget {
  final String endTime;

  MaintenanceScreenDialog({required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFE082), // Light yellow
              Color(0xFFFFC107), // Yellow
              Color(0xFFFFA000), // Dark yellow
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.build_rounded,
                size: 100,
                color: Colors.brown,
              ),
              SizedBox(height: 40),
              Text(
                "නඩත්තු ක්‍රියාමාර්ගය\nසිදු වෙමින් පවතී",
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Light background for contrast
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "අවසන් කාලය:",
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      endTime,
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 15,
                        color: Colors.brown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                child: Text(
                  "හරි",
                  style: GoogleFonts.notoSansSinhala(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.brown,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "අපගේ දැනුම්දීම සදහා ස්තූතියි!", // Thank you message
                style: GoogleFonts.notoSansSinhala(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 150, 150, 150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
