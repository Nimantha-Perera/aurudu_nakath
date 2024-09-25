import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';

class HelagptDrawer extends StatelessWidget {
  const HelagptDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.blueGrey[800]!, Colors.blueGrey[700]!],
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //   ),
        // ),
        child: Column(
          children: [
            _buildHeader(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: Colors.blueGrey[900], // Header background color
      child: DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                'https://avatars.githubusercontent.com/u/75797258?v=4',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Nimantha Perera',
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
        ),
      ),
    );
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
          color: Colors.white70,
        ),
      ),
    );
  }
}
