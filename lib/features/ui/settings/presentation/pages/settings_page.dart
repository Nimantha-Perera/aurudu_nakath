import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:aurudu_nakath/features/ui/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 16),
                  _buildSectionTitle('පෙනුම'),
                  _buildThemeSwitcher(context, themeNotifier),
                  Divider(height: 32, thickness: 0),
                  _buildSectionTitle('යෙදුම ගැන'),
                  _buildAppInfoSection(context),
                  Divider(height: 32, thickness: 0),
                  _buildSectionTitle('උපකාර'),
                  _buildSupportSection(context),
                ],
              ),
            ),
            _buildAppVersionSection(),
          ],
        ),
      ),
    );
  }

  // Theme Switcher with SharedPreferences check
  Widget _buildThemeSwitcher(BuildContext context, ThemeNotifier themeNotifier) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: ListTile(
        title: Text('අඳුරු මුහුනත', style: TextStyle(fontSize: 13)),
        trailing: Switch(
          value: themeNotifier.getTheme() == darkTheme,
          onChanged: (value) async {
            // Switch between light and dark themes and save preference
            themeNotifier.setTheme(value ? darkTheme : lightTheme);
            await themeNotifier.saveTheme(value ? 'dark' : 'light'); // Save the theme preference
          },
        ),
      ),
    );
  }

  // Section Title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: const Color.fromARGB(255, 107, 107, 107),
      ),
    );
  }

  // App Info Section
  Widget _buildAppInfoSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
          title: Text('මෙම යෙදුම ගැන', style: TextStyle(fontSize: 12)),
          subtitle: Text('මෙම යෙදුමේ විශේෂාංග ගැන තව දැනගන්න.', style: TextStyle(fontSize: 10)),
          onTap: () {
            // Navigate to the About Page
          },
        ),
      ],
    );
  }

  // Support Section
  Widget _buildSupportSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
          title: Text('උදව් සහ සහාය', style: TextStyle(fontSize: 12)),
          subtitle: Text('යෙදුම භාවිතයෙන් සහාය ලබා ගන්න.', style: TextStyle(fontSize: 11)),
          onTap: () {
            // Navigate to the Help & Support Page
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).primaryColor),
          title: Text('රහස්‍යතා ප්‍රතිපත්තිය', style: TextStyle(fontSize: 12)),
          subtitle: Text('අපගේ රහස්‍යතා ප්‍රතිපත්තිය සමාලෝචනය කරන්න.', style: TextStyle(fontSize: 11)),
          onTap: () {
            // Navigate to the Privacy Policy Page
          },
        ),
      ],
    );
  }

  // App Version Section (Centered at Bottom)
  Widget _buildAppVersionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            'App Version',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color.fromARGB(255, 109, 109, 109)),
          ),
          SizedBox(height: 4),
          Text(
            '2.2',
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
