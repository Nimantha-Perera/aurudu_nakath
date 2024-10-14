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
                "යෙදුම යාවත්කාලින\nවෙමින් පවතී",
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
                
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "අවසන් කිරීමට නිශ්චිත කාලය:",
                      style: GoogleFonts.notoSansSinhala(
                        fontSize: 17,
                        
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
              Center(
                child: Text(
                  "ක්‍රියාවලිය අවසන් වන තුරු මදක් රැදී සිටින්න.",textAlign: TextAlign.center, // Thank you message
                  style: GoogleFonts.notoSansSinhala(
                    fontSize: 12,
                    
                    fontWeight: FontWeight.w500,
                    color: const Color.fromARGB(255, 150, 150, 150),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
