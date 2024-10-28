import 'package:flutter/material.dart';
import 'package:aurudu_nakath/features/ui/subcriptions_provider/subcription_privider.dart';
import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:aurudu_nakath/features/ui/home/presentation/pages/buttons_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Tools extends StatefulWidget {
  const Tools({super.key});

  @override
  _ToolsState createState() => _ToolsState();
}

class _ToolsState extends State<Tools> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _checkUserId();
  }

  Future<void> _checkUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId');
    });
  }

  Future<String?> _checkUserIdLive() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Return the userId for live check
  }

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
              Text("අමතර මෙවලම්"),
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
                        onTap: () async {
                          // Check userId live on button click
                          final userIdLive = await _checkUserIdLive();
                          
                          if (userIdLive != null) {
                            if (subscriptionProvider.isSubscribed) {
                              Navigator.pushNamed(context, AppRoutes.helagptPro);
                            } else {
                              Navigator.pushNamed(context, AppRoutes.helagptnormless);
                            }
                          } else {
                            Navigator.pushNamed(context, AppRoutes.login2);
                          }
                        },
                        color: Color(0xFFA02334),
                        textColor: Colors.white,
                        icon: Icon(FontAwesomeIcons.commentDots, color: Colors.white),
                        width: buttonWidth,
                      );
                    },
                  ),
                  SizedBox(width: 10),
                  ButtonsCard(
                    text: "කැටපත",
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.katapatha);
                    },
                    color: Color(0xFFA02334),
                    textColor: Colors.white,
                    icon: Icon(FontAwesomeIcons.edit, color: Colors.white),
                    width: buttonWidth,
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
