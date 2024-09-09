import 'package:flutter/material.dart';

class ButtonsCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final Icon? icon; // Add an optional Icon parameter

  const ButtonsCard({
    super.key,
    required this.text,
    required this.textColor,
    required this.onTap,
    required this.color,
    this.icon, // Allow for an optional icon
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // To allow the icon to be positioned outside the button boundaries
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.2), // Shadow color
            //     spreadRadius: 2, // Spread radius
            //     blurRadius: 6, // Blur radius
            //     offset: Offset(0, 4), // Offset from the widget
            //   ),
            // ],
          ),
          child: TextButton(
            onPressed: onTap,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent), // Make the background transparent to show the shadow
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.zero),
              minimumSize: MaterialStateProperty.all<Size>(const Size(170, 100)),
              overlayColor: MaterialStateProperty.all<Color>(const Color.fromARGB(137, 255, 255, 255)),
            ),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor),
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
