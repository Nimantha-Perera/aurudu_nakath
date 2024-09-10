import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFFFABC3F),
    elevation: 0,
  ),
  primaryColorLight: Color(0xFFFFF3E0),
  canvasColor: const Color.fromARGB(255, 46, 46, 46),
  cardColor: Colors.white,
  focusColor: Color.fromARGB(255, 51, 51, 51),


  // Send btn Color
  primaryColor: Color(0xFFFABC3F),
  secondaryHeaderColor: Color.fromARGB(255, 255, 255, 255),
  
  colorScheme: const ColorScheme.light(
      background: Color.fromARGB(255, 245, 245, 245),
      primary: Color.fromARGB(255, 53, 53, 53), // Set your primary color
      secondary: Color.fromARGB(255, 255, 255, 255), // Set your secondary color
      surface: Color.fromARGB(255, 231, 231, 231), // Customize other color properties if needed
      tertiary: Color(0xFFE0FFC2)),
  fontFamily: GoogleFonts.notoSerifSinhala().fontFamily,
);
