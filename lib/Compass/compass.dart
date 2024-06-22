import 'package:aurudu_nakath/Compass/neu_corc;e.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
          return Text('Error reading heading: ${snapshot.error}');
        }

        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        // Extract the current heading from the snapshot
        double? heading = snapshot.data!.heading;

        if (heading == null) {
          return Center(
            child: Text('Compass data not available'),
          );
        }

        // You can use the heading value to display or manipulate your compass UI
        return NeuCircle(
          child: Transform.rotate(
            angle: (heading! * (math.pi / 180) * -1),
            child: Image.asset(
              'assets/malimawa/pngwing.com.png',
              color: Color.fromARGB(255, 71, 71, 71),
              fit: BoxFit.fill,
            ),
            alignment: Alignment.center,
          ),
        );
      },
    );
  }

  Widget _buildPermissionSheet() {
    // Replace with your actual permission request widget
    return Center(
        child: ElevatedButton(
            child: const Text('Request Location Permission'),
            onPressed: () async {
              Permission.locationWhenInUse.request().then((value) {
                _fetchPermissionStatus();
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6D003B),
      body: Stack(
        
        children: [
          Container(child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Text("මාලිමාව",style: TextStyle(color: Colors.white,fontSize: 30,fon),),
          )),
          _hasPermission ? _buildCompass() : _buildPermissionSheet(),
        ],
      ),
    );
  }
}
