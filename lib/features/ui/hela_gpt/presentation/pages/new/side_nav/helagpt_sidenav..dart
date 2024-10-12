import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_viewmodel.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';

class HelagptDrawer extends StatelessWidget {
  const HelagptDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);
    final user = loginViewModel.user;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Drawer(
       shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        color: isDarkMode ? Colors.grey[900] : Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(user, context, isDarkMode),
              Expanded(
                child: _buildDrawerItems(context, isDarkMode),
              ),
              _buildCopyright(isDarkMode),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic user, BuildContext context, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      child: FutureBuilder<Map<String, String?>>(
        future: _loadUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blue));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: TextStyle(color: Colors.red)));
          }

          final userData = snapshot.data!;
          final photoURL = userData['photoURL'];
          final displayName = userData['displayName'];

          return Column(
            children: [
              Hero(
                tag: 'user_avatar',
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Color.fromARGB(255, 255, 208, 0),
                  child: CircleAvatar(
                    radius: 47,
                    backgroundImage: photoURL != null
                        ? NetworkImage(photoURL)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    displayName ?? 'ඔබ අන්‍යයකුනේ',
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'හෙළ GPT ඔබගේ තාක්ශනික සහයක',
                style: GoogleFonts.notoSerifSinhala(
                  fontSize: 12,
                  color: isDarkMode ? Colors.grey[400] : Colors.black54,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItems(BuildContext context, bool isDarkMode) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerItem(
            context,
            icon: Icons.home,
            title: 'මුල් පිටුව',
            routeName: AppRoutes.home,
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.settings,
            title: 'සැකසුම්',
            routeName: AppRoutes.setting,
            isDarkMode: isDarkMode,
          ),
          _buildDrawerItem(
            context,
            icon: Icons.info,
            title: 'අපි ගැන',
            routeName: AppRoutes.help,
            isDarkMode: isDarkMode,
          ),
          ListTile(
            leading: Icon(Icons.logout,
                color: isDarkMode ? Colors.grey[400] : Color.fromARGB(255, 126, 126, 126)),
            title: Text(
              "ගිනුමෙන් ඉවත් වන්න",
              style: GoogleFonts.notoSerifSinhala(
                color: isDarkMode ? Colors.white : Colors.black87,
                fontSize: 13,
              ),
            ),
            onTap: () {
              final loginViewModel = Provider.of<LoginViewModel>(context,
                  listen: false); // Add listen: false
              loginViewModel.logout(context);
            },
            hoverColor: isDarkMode
                ? Colors.grey[800]
                : const Color.fromARGB(255, 194, 194, 194),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String routeName,
    required bool isDarkMode,
  }) {
    return ListTile(
      leading: Icon(icon, color: isDarkMode ? Colors.grey[400] : const Color.fromARGB(255, 126, 126, 126)),
      title: Text(
        title,
        style: GoogleFonts.notoSerifSinhala(
          color: isDarkMode ? Colors.white : Colors.black87,
          fontSize: 13,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop(); // Close the drawer
        Navigator.pushNamed(context, routeName);
      },
      hoverColor: isDarkMode
          ? Colors.grey[800]
          : const Color.fromARGB(255, 189, 189, 189),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  Widget _buildCopyright(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        '© 2024 LankaTechInnovations. All rights reserved.',
        textAlign: TextAlign.center,
        style: GoogleFonts.notoSerifSinhala(
          fontSize: 8,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? photoURL = prefs.getString('photoURL');
    String? displayName = prefs.getString('displayName');
    return {
      'photoURL': photoURL,
      'displayName': displayName,
    };
  }
}
