// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_compass/flutter_compass.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:permission_handler/permission_handler.dart';

// class Compass extends StatefulWidget {
//   const Compass({Key? key}) : super(key: key);

//   @override
//   State<Compass> createState() => _CompassPageState();
// }
//  bool hasLocationPermission = false;
// class _CompassPageState extends State<Compass> {
//   double heading = 0; // Change to non-nullable double

//   @override
//   void initState() {
//     super.initState();

//     FlutterCompass.events!.listen((event) {
//       if (mounted) {
//         // Check if the widget is still mounted before updating the state
//         setState(() {
//           heading = event.heading ?? 0; // Use null-aware operator to handle null
//         });
//       }
//     });
//   }
//    Future<void> checkLocationPermission() async {
//     // Request permission if not already granted
//     final status = await Permission.locationWhenInUse.request();
//     setState(() {
//       hasLocationPermission = status == PermissionStatus.granted;
//       checkLocationPermission();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//       appBar: AppBar(
//          backgroundColor: Color(0xFF6D003B),
//         centerTitle: true,
              
//           title: Text('මාලිමාව', style: GoogleFonts.notoSerifSinhala(fontSize: 14)),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 "${heading.ceil()} අංශක",
//                 style: const TextStyle(
//                   color: Color.fromARGB(255, 0, 0, 0),
//                   fontSize: 16,
                  
//                 ),
//               ),
//               Expanded(
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Image.asset("assets/malimawa/cadern.png", scale: 1.1),
//                     Transform.rotate(
//                       angle: (heading * (pi / 100) * -1),
//                       child: Image.asset("assets/malimawa/compass.png"),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
