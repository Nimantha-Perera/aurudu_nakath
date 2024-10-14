import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _profileName = '';
  String _profileImage = '';

  @override
  void initState() {
    super.initState();
    _getProfileInfo();
  }

  Future<void> _getProfileInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileName = prefs.getString('displayName') ?? 'Anonymous';
      _profileImage = prefs.getString('photoURL') ?? ''; // Default image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileImage(),
            const SizedBox(height: 16),
            _buildProfileName(),
            const SizedBox(height: 8),
            _buildProfileDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      backgroundImage:  _profileImage.isNotEmpty
                          ? NetworkImage(_profileImage) // Use the loaded profile image URL
                          : const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Default image,
      radius: 60,
      child: _profileImage.isEmpty
          ? const Icon(Icons.person, size: 60, color: Colors.white)
          : null,
    );
  }

  Widget _buildProfileName() {
    return Text(
      _profileName,
      style: GoogleFonts.notoSerifSinhala(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      children: [
        _buildDetailRow(Icons.email, 'Email: example@gmail.com'),

      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String detail) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Text(
          detail,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
