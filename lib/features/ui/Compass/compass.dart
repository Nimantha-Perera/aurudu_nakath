import 'package:aurudu_nakath/features/ui/compass/neu_corc;e.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

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
          child: SizedBox(
            width: 280,  // Adjust width as desired
            height: 280, // Adjust height as desired
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildCompass(),
              ),
              if (!_hasPermission) _buildPermissionSheet(),
            ],
          ),
        ],
      ),
    );
  }
}
