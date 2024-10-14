
import 'package:aurudu_nakath/features/ui/settings/data/repostories/settings_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurudu_nakath/features/ui/settings/domain/entities/user_settings.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  static const String _themeKey = 'theme';
  static const String _notificationsEnabledKey = 'notificationsEnabled';

  @override
  Future<UserSettings> getUserSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Fetch saved theme and notification settings
    final theme = prefs.getString(_themeKey) ?? 'light'; // Default to light theme
    final notificationsEnabled =
        prefs.getBool(_notificationsEnabledKey) ?? true; // Default to notifications enabled

    return UserSettings(
      notificationsEnabled: notificationsEnabled,
      theme: theme,
    );
  }

  @override
  Future<void> saveUserSettings(UserSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    // Save the theme and notification settings
    await prefs.setString(_themeKey, settings.theme);
    await prefs.setBool(_notificationsEnabledKey, settings.notificationsEnabled);
  }

  // Apply the saved theme to the app
  Future<ThemeMode> getSavedThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString(_themeKey) ?? 'light'; // Default to light theme
    return theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }
}
