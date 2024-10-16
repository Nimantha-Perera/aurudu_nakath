import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Jyothishya extends StatelessWidget {
  const Jyothishya({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity, // Set height for the horizontal list
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ජ්‍යෝතීශ්‍ය",
               
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.other_tools);
                },
                child: Text(
                  "තවත් >",
                  style: TextStyle(color: const Color.fromARGB(255, 124, 124, 124), fontSize: 10),
                ),
              )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ButtonsCard(
                  width: double.infinity,
                  text: "අවුරුදු නැකැත්",
                  onTap: () => {
                    Navigator.pushNamed(context, AppRoutes.aurudu_nakath)
                  },
                  color: Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: Icon(FontAwesomeIcons.wpexplorer, color: Colors.white),
                ),
              ),
              SizedBox(width: 10), // Add some spacing between cards
              Expanded(
                child: ButtonsCard(
                  width: double.infinity,
                  text: "‍රාහු කාලය",
                  onTap: () => {
                    Navigator.pushNamed(context, AppRoutes.rahu_kalaya)
                  },
                  color: Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: Icon(Icons.watch_later_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
