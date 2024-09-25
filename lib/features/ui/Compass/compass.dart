import 'package:aurudu_nakath/features/ui/compass/neu_circle.dart';
import 'package:aurudu_nakath/features/ui/theme/change_theme_notifier.dart';
import 'package:aurudu_nakath/features/ui/theme/dark_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import 'package:provider/provider.dart';

class Compass extends StatefulWidget {
  const Compass({super.key});

  @override
  State<Compass> createState() => _CompassState();
}

class _CompassState extends State<Compass> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  void _fetchPermissionStatus() async {
    var status = await Permission.locationWhenInUse.status;
    if (mounted) {
      setState(() {
        _hasPermission = (status == PermissionStatus.granted);
      });
    }
  }

Widget _buildCompass() {
  return StreamBuilder<CompassEvent>(
    stream: FlutterCompass.events,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
            child: Text('Error reading heading: ${snapshot.error}'));
      }

      if (!snapshot.hasData) {
        return Center(child: CircularProgressIndicator());
      }

      double? heading = snapshot.data!.heading;

      if (heading == null) {
        return Center(child: Text('Compass data not available'));
      }

      return Center(
        child: Tooltip( // Add Tooltip here
          message: 'මෙය ඔබගේ වර්තමාන දිශාව පෙන්වයි', // Tooltip text in Sinhala
          child: SizedBox(
            width: 280,
            height: 280,
            child: NeuCircle(
              child: Transform.rotate(
                angle: (heading * (math.pi / 180) * -1),
                child: Image.asset(
                  'assets/compass/sincom.png',
                  color: Colors.black87,
                  fit: BoxFit.fill,
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ),
      );
    },
  );
}


  Widget _buildPermissionSheet() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        child: Text('Grant Location Permission'),
        onPressed: () async {
          Permission.locationWhenInUse.request().then((value) {
            _fetchPermissionStatus();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('මාලිමාව',
            style: GoogleFonts.notoSerifSinhala(
                fontSize: 14.0, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/background.jpg',
          //     fit: BoxFit.cover,
          //   ),
          // ),

          Opacity(
            opacity: themeNotifier.getTheme() == darkTheme ? 0.8 : 0.2,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    themeNotifier.getTheme() == darkTheme
                        ? 'assets/app_background/backimg.png' // Dark mode image
                        : 'assets/app_background/backimg.png', // Light mode image
                  ),
                  fit: BoxFit.cover, // Adjust how the image fits the background
                ),
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    'නිවැරදි දිශාව ලබාගැනීම සඳහා ඔබගේ විද්‍යුත් උපකරන වලින් ඈත්ව ඇති ස්තානයක ඔබගේ දුරකතනය ස්තානගත කරන්න.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 14,
                      color: const Color.fromARGB(179, 119, 119, 119),
                    ),
                  ),
                ),
                // SizedBox(width: 12),
                // Icon(
                //   FontAwesomeIcons.arrowUp,
                //   color: Colors.white70,
                //   size: 20,
                // ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildCompass(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
