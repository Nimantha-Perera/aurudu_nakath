import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:aurudu_nakath/features/ui/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'theme';
  ThemeData _currentTheme;

  ThemeNotifier([ThemeData? initialTheme]) : _currentTheme = initialTheme ?? lightTheme;

  ThemeData getTheme() => _currentTheme;

  Future<void> setTheme(ThemeData theme) async {
    _currentTheme = theme;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme == darkTheme ? 'dark' : 'light');
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'light';

    _currentTheme = themeString == 'dark' ? darkTheme : lightTheme;
    notifyListeners();
  }

  Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme);
  }
}
