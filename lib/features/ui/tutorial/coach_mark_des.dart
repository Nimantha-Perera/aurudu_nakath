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
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.white),
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
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: onNext,
                child: Text(
                  "Next",
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
