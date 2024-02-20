import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';

class Compass extends StatefulWidget {
  const Compass({Key? key}) : super(key: key);

  @override
  State<Compass> createState() => _CompassPageState();
}

class _CompassPageState extends State<Compass> {
  double? heading = 0;

  @override
  void initState() {
    super.initState();
    FlutterCompass.events!.listen((event) {
      setState(() {
        heading = event.heading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text("Compass Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "${heading!.ceil()} degrees",
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset("assets/malimawa/cadern.png", scale: 1.1),
                    Transform.rotate(
                      angle: (heading! * (pi / 100) * -1),
                      child: Image.asset("assets/malimawa/compass.png"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
