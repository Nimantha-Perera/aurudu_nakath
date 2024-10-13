import 'package:flutter/material.dart';

class CoachMarkDes extends StatelessWidget {
  final String text;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const CoachMarkDes({
    Key? key,
    required this.text,
    required this.onNext,
    required this.onSkip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        // Background color adapts to dark mode
        color: isDarkMode ? Colors.black87 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            // Text color adapts to dark mode
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: onSkip,
                child: Text(
                  "Skip",
                  // Skip button color adapts to dark mode
                  style: TextStyle(color: isDarkMode ? Colors.red[300] : Colors.red),
                ),
              ),
              TextButton(
                onPressed: onNext,
                child: Text(
                  "Next",
                  // Next button color adapts to dark mode
                  style: TextStyle(color: isDarkMode ? Colors.green[300] : Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
