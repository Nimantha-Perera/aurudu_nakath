import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/jyothishya_sewa.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/tools_view.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60),
                    Text(
                      "විශේෂ දැනුම්දීම්",
                      // Optional: Use a theme style
                    ),
                    SizedBox(height: 20),
                    // Notice Card 1
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color.fromARGB(255, 184, 184, 184),
                      ),
                      height: 120,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text("Noice"),
                    ),
                    SizedBox(height: 50),

                    // Jyothishya Sewa
                    Jyothishya(),

                    // Tools
                    Tools(),
                  ],
                ),
              ),
            ),
          ),
          // Settings icon
          Positioned(
            top: 30,
            right: 30,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[200],
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Handle settings icon tap
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
