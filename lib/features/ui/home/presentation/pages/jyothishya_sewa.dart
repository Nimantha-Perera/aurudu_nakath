import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:flutter/material.dart';

class Jyothishya extends StatelessWidget {
  const Jyothishya({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, // Set height for the horizontal list
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ජ්‍යෝතීශ්‍ය",
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    "තවත් >",
                    style: TextStyle(color: Colors.blue, fontSize: 10),
                  ))
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              
              ButtonsCard(
                  text: "Item 1",
                  onTap: () => {},
                ),
              
             ButtonsCard(
                  text: "Item 2",
                  onTap: () => {},
                ),
              
              // Add more items as needed with similar padding
            ],
          ),
        ],
      ),
    );
  }
}
