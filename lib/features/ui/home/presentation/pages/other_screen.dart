import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:flutter/material.dart';

class Other_Tools extends StatefulWidget {
  const Other_Tools({super.key});

  @override
  State<Other_Tools> createState() => _Other_ToolsState();
}

class _Other_ToolsState extends State<Other_Tools> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(0, 255, 193, 7),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true, // To make the GridView take only the needed space
              crossAxisCount: 2, // Display 2 buttons per row
              mainAxisSpacing: 20, // Vertical spacing between the buttons
              crossAxisSpacing: 20, // Horizontal spacing between the buttons
              children: [
                ButtonsCard(
                  text: "අවුරුදු නැකැත්",
                  onTap: () => Navigator.pushNamed(context, AppRoutes.aurudu_nakath),
                  color: const Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: const Icon(Icons.timelapse_rounded, color: Colors.white),
                ),
                ButtonsCard(
                  text: "‍රාහු කාලය",
                  onTap: () => Navigator.pushNamed(context, AppRoutes.rahu_kalaya),
                  color: const Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: const Icon(Icons.watch_later_rounded, color: Colors.white),
                ),
                ButtonsCard(
                  text: "ලිත",
                  onTap: () => Navigator.pushNamed(context, AppRoutes.litha),
                  color: const Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: const Icon(Icons.document_scanner_rounded, color: Colors.white),
                ),
                ButtonsCard(
                  text: "ලග්න පලාඵල",
                  onTap: () => Navigator.pushNamed(context, AppRoutes.lagna),
                  color: const Color(0xFFFABC3F),
                  textColor: const Color.fromARGB(255, 83, 83, 83),
                  icon: const Icon(Icons.shelves, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
