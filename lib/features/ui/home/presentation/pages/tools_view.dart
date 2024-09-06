import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150, // Set height for the horizontal list
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to start of column
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:0), // Adds padding for better spacing
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "වෙනත් මෙවලම්",
                  // Use theme style for consistency
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
                      text: "Item 1",
                      onTap: () {},
                    ),

                    SizedBox(width: 10),
                  
                   ButtonsCard(
                      text: "Item 2",
                      onTap: () {},
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
