import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:aurudu_nakath/features/ui/theme/light_theme.dart';

class ThemeNotifier extends ChangeNotifier {
  static const String _themeKey = 'theme';
  late ThemeMode _themeMode;
  ThemeData _currentTheme;

  ThemeNotifier([ThemeData? initialTheme])
      : _currentTheme = initialTheme ?? lightTheme,
        _themeMode = ThemeMode.system;

  ThemeData getTheme() => _currentTheme;
  ThemeMode getThemeMode() => _themeMode;

  Future<void> setTheme(ThemeData theme) async {
    _currentTheme = theme;
    _themeMode = theme == darkTheme ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, theme == darkTheme ? 'dark' : 'light');
  }

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey) ?? 'system'; // Default to system theme

    switch (themeString) {
      case 'dark':
        _currentTheme = darkTheme;
        _themeMode = ThemeMode.dark;
        break;
      case 'light':
        _currentTheme = lightTheme;
        _themeMode = ThemeMode.light;
        break;
      default:
        _themeMode = ThemeMode.system; // Use system theme
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        _currentTheme = brightness == Brightness.dark ? darkTheme : lightTheme;
    }

    notifyListeners();
  }

  Future<void> saveTheme(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, isDarkMode ? 'dark' : 'light');
  }

  Future<void> switchThemeMode(ThemeMode mode) async {
    _themeMode = mode;

    // Automatically choose theme based on system settings if system mode is selected
    if (mode == ThemeMode.system) {
      final brightness = WidgetsBinding.instance.window.platformBrightness;
      _currentTheme = brightness == Brightness.dark ? darkTheme : lightTheme;
    } else {
      _currentTheme = mode == ThemeMode.dark ? darkTheme : lightTheme;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode == ThemeMode.dark
        ? 'dark'
        : mode == ThemeMode.light
            ? 'light'
            : 'system');
    notifyListeners();
  }
}
