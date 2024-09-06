import 'package:flutter/material.dart';

class ButtonsCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap; // Callback for handling the click event

  const ButtonsCard({
    super.key,
    required this.text,
    required this.onTap, // Initialize the callback
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap, // Trigger the callback on press
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 184, 184, 184), // Background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Border radius
        ),
        padding: EdgeInsets.zero, // Remove default padding
        minimumSize: Size(170, 100), // Set width and height for the button
      ),
      child: Center( // Center the content inside the button
        child: Text(
          text,
          // style: Theme.of(context).textTheme.bodyText1?.copyWith(
          //   fontSize: 16, // Customize the font size if needed
          //   fontWeight: FontWeight.bold, // Customize the font weight if needed
          // ),
          textAlign: TextAlign.center, // Center text horizontally
        ),
      ),
    );
  }
}
