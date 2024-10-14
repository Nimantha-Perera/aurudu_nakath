import 'dart:ui';

import 'package:flutter/material.dart';

class ButtonsCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final Icon? icon; // Add an optional Icon parameter
  final double width; // Add a width parameter

  const ButtonsCard({
    super.key,
    required this.text,
    required this.textColor,
    required this.onTap,
    required this.color,
    this.icon, // Allow for an optional icon
    required this.width, // Require width
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // To allow the icon to be positioned outside the button boundaries
      children: [
        Container(
          width: width, // Use the width here
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all<Size>(Size(width, 100)),
              overlayColor: MaterialStateProperty.all<Color>(Color.fromARGB(137, 255, 255, 255)),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
            ),
          ),
        ),
        if (icon != null) // Conditionally add the icon if it's provided
          Positioned(
            top: 8,
            right: 8,
            child: icon!,
          ),
      ],
    );
  }
}
