import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart'; // Import provider for subscription management

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final double screenWidth = MediaQuery.of(context).size.width;

    // Calculate the width of each button (you can adjust the ratio as needed)
    final double buttonWidth = screenWidth * 0.4; // Each button takes 40% of the screen width

    return Container(
      height: 120,
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "අමතර මෙවලම්",
             
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
                  Consumer<SubscriptionProvider>(
                    builder: (context, subscriptionProvider, child) {
                      return ButtonsCard(
                        text: "හෙළ GPT",
                        onTap: () {
                          if (subscriptionProvider.isSubscribed) {
                            // If the user is subscribed, navigate to HelaGPT Pro
                            Navigator.pushNamed(context, AppRoutes.helagptPro);
                          } else {
                            // If the user is not subscribed, navigate to normal HelaGPT
                            Navigator.pushNamed(context, AppRoutes.helagptnormless);
                          }
                        },
                        color: Color(0xFFA02334),
                        textColor: Colors.white,
                        icon: Icon(FontAwesomeIcons.commentDots, color: Colors.white),
                        width: buttonWidth, // Use the calculated button width
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  ButtonsCard(
                    text: "මාලිමාව",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.malimawa);
                    },
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(FontAwesomeIcons.safari, color: Colors.white),
                    width: buttonWidth, // Use the calculated button width
                  ),
                  SizedBox(width: 10),
                  ButtonsCard(
                    text: "සැකසුම්",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.setting);
                    },
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(Icons.settings, color: Colors.white),
                    width: buttonWidth, // Use the calculated button width
                  ),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
