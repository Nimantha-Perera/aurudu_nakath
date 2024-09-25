import 'package:aurudu_nakath/features/ui/Login/presentation/pages/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Tools extends StatelessWidget {
  const Tools({super.key});

  @override
  Widget build(BuildContext context) {
    // Get screen width
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.4;

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      return FutureBuilder<bool>(
                        future: Provider.of<LoginViewModel>(context, listen: false).checkLoginStatus(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Show a loading indicator while checking
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}'); // Handle errors
                          }

                          final isLoggedIn = snapshot.data ?? false;

                          return ButtonsCard(
                            text: "හෙළ GPT",
                            onTap: () {
                              if (isLoggedIn) {
                                // User is logged in
                                if (subscriptionProvider.isSubscribed) {
                                  Navigator.pushNamed(context, AppRoutes.helagptPro);
                                } else {
                                  Navigator.pushNamed(context, AppRoutes.helagptnormless);
                                }
                              } else {
                                // User is not logged in
                                Navigator.pushNamed(context, AppRoutes.login);
                              }
                            },
                            color: Color(0xFFA02334),
                            textColor: Colors.white,
                            icon: Icon(FontAwesomeIcons.commentDots, color: Colors.white),
                            width: buttonWidth,
                          );
                        },
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
                    width: buttonWidth,
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
                    width: buttonWidth,
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
