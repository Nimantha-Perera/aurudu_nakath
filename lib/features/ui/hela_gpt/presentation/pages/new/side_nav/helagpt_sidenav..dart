import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelagptDrawer extends StatelessWidget {
  const HelagptDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final user = loginViewModel.user; // Get the logged-in user

    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            _buildHeader(user, context), // Pass the user to the header
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    icon: Icons.home,
                    title: 'මුල් පිටුව',
                    routeName: AppRoutes.home,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.settings,
                    title: 'සැකසුම්',
                    routeName: AppRoutes.setting,
                  ),
                  _buildDrawerItem(
                    context,
                    icon: Icons.info,
                    title: 'අපි ගැන',
                    routeName: AppRoutes.help,
                  ),
                  const Divider(color: Color.fromARGB(255, 177, 177, 177), thickness: 0.4),
                ],
              ),
            ),
            _buildCopyright(), // Add the copyright widget here
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, BuildContext context) { // Accept user parameter
    return Container(
      width: double.infinity,
      color: Colors.blueGrey[900], // Header background color
      child: DrawerHeader(
        child: FutureBuilder<Map<String, String?>>(
          future: _loadUserData(), // Load user data from SharedPreferences
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator()); // Show loading indicator
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}')); // Handle errors
            }

            final userData = snapshot.data!;
            final photoURL = userData['photoURL'];
            final displayName = userData['displayName'];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: photoURL != null
                      ? NetworkImage(photoURL) // Use user's photo URL
                      : AssetImage('assets/images/default_avatar.png') as ImageProvider, // Fallback image
                ),
                SizedBox(height: 8),
                Text(
                  displayName ?? 'ඔබ අන්‍යයකුනේ', // Default text if no user is logged in
                  style: GoogleFonts.notoSerifSinhala(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'හෙළ GPT ඔබගේ සහයක',
                  style: GoogleFonts.notoSerifSinhala(
                    fontSize: 10,
                    color: Colors.white70,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photoURL = prefs.getString('photoURL'); // Get the photo URL from SharedPreferences
    String? displayName = prefs.getString('displayName'); // Get the display name
    return {
      'photoURL': photoURL,
      'displayName': displayName,
    };
  }

  Widget _buildDrawerItem(BuildContext context, {
    required IconData icon,
    required String title,
    required String routeName,
  }) {
    return ListTile(
      leading: Icon(icon, color: const Color.fromARGB(255, 168, 168, 168)),
      title: Text(
        title,
        style: GoogleFonts.notoSerifSinhala(color: const Color.fromARGB(255, 167, 167, 167)),
      ),
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
    );
  }

  // New method to build the copyright section
  Widget _buildCopyright() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '© 2024 LankaTeckInnovations. All rights reserved.',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerifSinhala(
          fontSize: 12,
          color: const Color.fromARGB(179, 124, 124, 124),
        ),
      ),
    );
  }
}
