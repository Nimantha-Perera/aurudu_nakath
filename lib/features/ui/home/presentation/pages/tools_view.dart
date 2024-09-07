import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 50), // Set height for the horizontal list
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "අමතර මෙවලම්",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Horizontal scrollable list of buttons
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ButtonsCard(
                    text: "හෙළ GPT",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.hela_gpt);
                    },
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(Icons.arrow_outward_rounded, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  ButtonsCard(
                    text: "මාලිමාව",
                    onTap: () {},
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(Icons.compass_calibration, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  ButtonsCard(
                    text: "සැකසුම්",
                    onTap: () {},
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(Icons.settings, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                  // Add more buttons if needed
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
