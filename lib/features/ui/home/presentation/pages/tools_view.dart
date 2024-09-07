import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Set height for the horizontal list
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns children to start of column
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 0), // Adds padding for better spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "වෙනත් මෙවලම්",
                  // Use theme style for consistency
                     style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
          SizedBox(height: 40), // Reduced height for better spacing
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ButtonsCard(
                    text: "හෙළ GPT",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.hela_gpt);
                    },
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon:
                        Icon(Icons.arrow_outward_rounded, color: Colors.white),
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

                  // Add more items as needed with similar padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
