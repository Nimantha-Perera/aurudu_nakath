import 'dart:io';
import 'dart:typed_data';

import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
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
  String _email = '';
  bool _isEmailVerified = false;

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

  // Future<void> _getProfileInfo() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _email = prefs.getString('email') ?? '';
  //     _profileName = prefs.getString('displayName') ?? '';
  //     _profileImage = prefs.getString('photoURL') ??
  //         'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';
  //         ''; // If image is empty, we will show a button
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('සැකසුම්',
            style: GoogleFonts.notoSerifSinhala(
                fontSize: 14.0, color: Colors.white)),
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
                  _buildProfileSection(
                      context), // Conditionally show profile or Sign In button
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

  // Profile Section (Shows either profile view or a Sign In button)
  Widget _buildProfileSection(BuildContext context) {
    if (_profileName.isEmpty) {
      // Show "Sign In" button if profile info is missing
      return _buildSignInButton(context);
    } else {
      // Show profile view if info is available
      return _buildProfileViewSection(context);
    }
  }

  // Profile View Section
Future<void> _getProfileInfo() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.reload();  // Reload the user to get the latest email verification status
    final updatedUser = FirebaseAuth.instance.currentUser;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    setState(() {
      _email = updatedUser?.email ?? '';
      _isEmailVerified = updatedUser?.emailVerified ?? false;
      _profileName = prefs.getString('displayName') ?? '';
      _profileImage = prefs.getString('photoURL') ?? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png';
    });
  }


  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('තහවුරු කිරීමේ ඊමේල් පණිවිඩය යවා ඇත. කරුණාකර ඔබගේ ඊමේල් පරීක්ෂා කරන්න.'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('තහවුරු කිරීමේ ඊමේල් පණිවිඩය යැවීමට අසමත් විය. පසුව නැවත උත්සාහ කරන්න.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildProfileViewSection(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: _profileImage.isNotEmpty
                        ? NetworkImage(_profileImage)
                        : const NetworkImage(
                            'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                    radius: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _profileName,
              style: GoogleFonts.roboto(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    _email,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  _isEmailVerified ? Icons.verified : Icons.warning,
                  color: _isEmailVerified ? Colors.green : Colors.orange,
                  size: 20,
                ),
              ],
            ),
            if (!_isEmailVerified) ...[
              const SizedBox(height: 16),
              Text(
                'ඊමේල් ලිපිනය තහවුරු කර නැත',
                style: GoogleFonts.notoSerifSinhala(
                  fontSize: 14,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _sendVerificationEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                icon: const Icon(Icons.email, size: 18),
                label: Text(
                  'තහවුරු කිරීමේ ඊමේල් පණිවිඩය යවන්න',
                  style: GoogleFonts.notoSerifSinhala(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
                loginViewModel.logout(context);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              icon: const Icon(Icons.logout),
              label: Text(
                'ගිනුමෙන් ඉවත් වන්න.',
                style: GoogleFonts.notoSerifSinhala(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Sign In Button
  Widget _buildSignInButton(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'ඔබ පුරනය වී නොමැත',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Sign In screen
                Navigator.pushNamed(context, AppRoutes.login2);
              },
              child: Text('පුරනය වන්න', style: TextStyle(fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  // Theme Switcher with light, dark, and system options
  Widget _buildThemeSwitcher(
      BuildContext context, ThemeNotifier themeNotifier) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 3,
      child: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text('පද්ධති මුහුණත අනුව (System Default)',
                style: TextStyle(fontSize: 13)),
            value: ThemeMode.system,
            groupValue: themeNotifier.getThemeMode(),
            onChanged: (value) {
              themeNotifier.switchThemeMode(ThemeMode.system);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('ආලෝක මුහුණත (Light Mode)',
                style: TextStyle(fontSize: 13)),
            value: ThemeMode.light,
            groupValue: themeNotifier.getThemeMode(),
            onChanged: (value) {
              themeNotifier.switchThemeMode(ThemeMode.light);
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('අඳුරු මුහුණත (Dark Mode)',
                style: TextStyle(fontSize: 13)),
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
          leading:
              Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
          title: Text('මෙම යෙදුම ගැන', style: TextStyle(fontSize: 12)),
          subtitle: Text('මෙම යෙදුමේ විශේෂාංග ගැන තව දැනගන්න.',
              style: TextStyle(fontSize: 10)),
          onTap: () {
            // Navigate to the About Page
          },
        ),
      ],
    );
  }
void _showNoWhatsAppClientDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('WhatsApp යැවීම අසාර්ථකයි'),
        content: Text('WhatsApp යැවීම සඳහා WhatsApp යෙදුමක් නොමැත. කරුණාකර පරිශීලනයට ඇප් එකක් ස්ථාපනය කරන්න.'),
        actions: <Widget>[
          TextButton(
            child: Text('හරි'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
  // Support Section
  Widget _buildSupportSection(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading:
              Icon(Icons.help_outline, color: Theme.of(context).primaryColor),
          title: Text('උදව් සහ සහාය', style: TextStyle(fontSize: 12)),
          subtitle: Text('යෙදුම භාවිතයෙන් සහාය ලබා ගන්න.',
              style: TextStyle(fontSize: 11)),
          onTap: () {
            // Navigate to the Help & Support Page
            Navigator.pushNamed(context, AppRoutes.help);
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined,
              color: Theme.of(context).primaryColor),
          title: Text('රහස්‍යතා ප්‍රතිපත්තිය', style: TextStyle(fontSize: 12)),
          subtitle: Text('අපගේ රහස්‍යතා ප්‍රතිපත්තිය සමාලෝචනය කරන්න.',
              style: TextStyle(fontSize: 11)),
          onTap: () {
            // Navigate to the Privacy Policy Page
            _launchURL(
                'https://www.termsfeed.com/live/79b4e42a-4f42-42ed-a50e-9d06b3bbf0d0');
          },
        ),
        ListTile(
          leading: Icon(Icons.privacy_tip_outlined,
              color: Theme.of(context).primaryColor),
          title: Text('දෝශ වාර්තා කරන්න', style: TextStyle(fontSize: 12)),
          subtitle: Text('ඇප් එක පිලිබඳ දෝශ ඇත්නම් වාර්තා කරන්න.',
              style: TextStyle(fontSize: 11)),
          onTap: () {
           BetterFeedback.of(context).show((feedback) async {
          // Save the screenshot to storage
          final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

          // Attempt to send the email
        BetterFeedback.of(context).show((feedback) async {
            // Save the screenshot to storage
            final screenshotFilePath = await writeImageToStorage(feedback.screenshot);

            // Prepare the message with the error feedback
        
             final uri = Uri.parse(
              'https://wa.me/94762938664?text=$feedback%0A%0A%3CAttachment%3E%20$screenshotFilePath'
            );


            // Open WhatsApp
            if (await canLaunch(uri.toString())) {
              await launch(uri.toString());
            } else {
              _showNoWhatsAppClientDialog(context);
            }
          });
        });
          },
        )
      ],
    );
  }




// Helper method to show dialog when no email client is available
void _showNoEmailClientDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('ඊමේල් යැවීම අසාර්ථකයි'),
        content: Text('ඊමේල් යැවීම සඳහා ඊමේල් යැවීමේ යෙදුමක් නොමැත. කරුණාකර පරිශීලනයට ඇප් එකක් ස්ථාපනය කරන්න.'),
        actions: <Widget>[
          TextButton(
            child: Text('හරි'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}


  Future<String> writeImageToStorage(Uint8List _image) async {
    final directory = await getTemporaryDirectory();
    final imagePath = '${directory.path}/image.jpg';
    final file = File(imagePath);
    await file.writeAsBytes(_image);
    return imagePath;
  }

  // App Version Section
  Widget _buildAppVersionSection(BuildContext context) {
    return Text(
      'සංස්කරණය: $_version',
      style: TextStyle(
        fontSize: 10,
        color: Theme.of(context).textTheme.bodySmall?.color,
      ),
    );
  }
}
