import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: AppBarTheme(
    backgroundColor: const Color.fromARGB(255, 36, 36, 36),
    elevation: 0,
  ),
  
  focusColor: Color.fromARGB(255, 197, 197, 197),
  primaryColorLight: Color.fromARGB(255, 143, 143, 143),
  cardColor: Color.fromARGB(255, 54, 54, 54),
  canvasColor: Colors.white,
  primaryColor: Color.fromARGB(255, 255, 255, 255),
  secondaryHeaderColor: Color.fromARGB(255, 0, 0, 0),
  colorScheme: const ColorScheme.dark(
      background: Color.fromARGB(255, 12, 12, 12),
      primary: Color.fromARGB(255, 255, 255, 255), // Set your primary color
      secondary: Color.fromARGB(255, 41, 41, 41), // Set your secondary color
      surface: Color.fromARGB(
          255, 99, 99, 99), // Customize other color properties if needed
      tertiary: Color.fromARGB(255, 59, 59, 59)),
  fontFamily: GoogleFonts.notoSerifSinhala().fontFamily,
);
