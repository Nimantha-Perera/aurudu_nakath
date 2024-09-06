import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
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
                // Use theme style for consistency
                style: TextStyle(fontSize: 12),
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
                  text: "අවුරුදු නැකැත්",
                  onTap: () => {
                     Navigator.pushNamed(context, AppRoutes.nakathSittuwa)
                  },
                  color: Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  
                   icon: Icon(Icons.timelapse_rounded, color: Colors.white), // Example icon // Example icon
                ),
              
             ButtonsCard(
                  text: "‍රාහු කාලය",
                  onTap: () => {
                     Navigator.pushNamed(context, AppRoutes.rahu_kalaya)
                  },
                  color: Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: Icon(Icons.watch_later_rounded, color: Colors.white),
                  
                ),
              
              // Add more items as needed with similar padding
            ],
          ),
        ],
      ),
    );
  }
}
