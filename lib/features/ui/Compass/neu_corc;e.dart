import 'package:flutter/material.dart';

class NeuCircle extends StatelessWidget {
  final Widget child;

  const NeuCircle({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      margin: EdgeInsets.all(40),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white, // Set background color to white
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Set shadow color to black
            offset: Offset(4.0, 4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Set shadow color to black
            offset: Offset(-4.0, -4.0),
            blurRadius: 15.0,
            spreadRadius: 1.0,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color.fromARGB(255, 255, 255, 255),
            const Color.fromARGB(255, 255, 255, 255),
            Color.fromARGB(255, 255, 255, 255),
            Colors.brown.shade800,
          ],
          stops: [0.1, 0.3, 0.8, 1],
        ),
      ),
      child: child,
    );
  }
}
