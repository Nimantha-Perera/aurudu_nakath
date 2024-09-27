import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _version = '';
  String _profileName = '';
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _getProfileInfo(); // Get profile info when the page is initialized
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version; // Get the app version
    });
  }

  Future<void> _getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileName = prefs.getString('displayName') ?? 'Anonymous';
      _profileImage = prefs.getString('photoURL') ?? 'https://i.pravatar.cc/150?u=a042581f4e29026704d'; // Default image
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('සැකසුම්', style: GoogleFonts.notoSerifSinhala(fontSize: 14.0, color: Colors.white)),
        centerTitle: true,
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
                  _buildSectionTitle('පරිශීලක පැතිකඩ'), // User Profile Section
                  _buildProfileViewSection(context), // Change this method to view-only
                  Divider(height: 32, thickness: 0),
                  _buildSectionTitle('යෙදුම ගැන'),
                  _buildAppInfoSection(context),
                  Divider(height: 32, thickness: 0),
                  _buildSectionTitle('උපකාර'),
                  _buildSupportSection(context),
                ],
              ),
            ),
            _buildAppVersionSection(context),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Profile View Section
  Widget _buildProfileViewSection(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: _profileImage.isNotEmpty
                          ? NetworkImage(_profileImage) // Use the loaded profile image URL
                          : const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Default image
              radius: 40,
            ),
            SizedBox(height: 16),
            // Displaying the profile name without editing
            Text(
              _profileName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // Theme Switcher with light, dark, and system options
  Widget _buildThemeSwitcher(BuildContext context, ThemeNotifier themeNotifier) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text('පද්ධති මුහුණත අනුව (System Default)', style: TextStyle(fontSize: 13)),
            value: ThemeMode.system,
            groupValue: themeNotifier.getThemeMode(),
            onChanged: (value) {
              themeNotifier.switchThemeMode(ThemeMode.system);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('ආලෝක මුහුණත (Light Mode)', style: TextStyle(fontSize: 13)),
            value: ThemeMode.light,
            groupValue: themeNotifier.getThemeMode(),
            onChanged: (value) {
              themeNotifier.switchThemeMode(ThemeMode.light);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('අඳුරු මුහුණත (Dark Mode)', style: TextStyle(fontSize: 13)),
            value: ThemeMode.dark,
            groupValue: themeNotifier.getThemeMode(),
            onChanged: (value) {
              themeNotifier.switchThemeMode(ThemeMode.dark);
            },
          ),
        ],
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
            Navigator.pushNamed(context, AppRoutes.help);
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined, color: Theme.of(context).primaryColor),
          title: Text('රහස්‍යතා ප්‍රතිපත්තිය', style: TextStyle(fontSize: 12)),
          subtitle: Text('අපගේ රහස්‍යතා ප්‍රතිපත්තිය සමාලෝචනය කරන්න.', style: TextStyle(fontSize: 11)),
          onTap: () {
            // Navigate to the Privacy Policy Page
            _launchURL('https://www.termsfeed.com/live/79b4e42a-78ea-4d2f-a44a-273ab4006846');
          },
        ),
      ],
    );
  }

  // App Version Section (Centered at Bottom)
  Widget _buildAppVersionSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Text(
            'App Version',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 109, 109, 109),
            ),
          ),
          SizedBox(height: 4),
          Text(
            _version.isNotEmpty ? _version : 'Loading...', // Show version when loaded
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
