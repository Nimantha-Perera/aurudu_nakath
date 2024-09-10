import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:aurudu_nakath/features/ui/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFFFABC3F),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            Text(
              'Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            SizedBox(height: 8),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              child: Column(
                children: [
                  ListTile(
                    title: Text('Light Theme'),
                    trailing: Switch(
                      value: themeNotifier.getTheme() == darkTheme,
                      onChanged: (value) {
                        themeNotifier.setTheme(value ? darkTheme : lightTheme);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
