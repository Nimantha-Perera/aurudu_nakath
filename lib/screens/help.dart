import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';



class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

 class _HelpState extends State<Help> {
   InterstitialAdManager interstitialAdManager = InterstitialAdManager();
   
  @override
  void initState() {
    super.initState();
    
    interstitialAdManager.initInterstitialAd();
    
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BackButtonUtil.handleBackButton(interstitialAdManager);

        return true; // Return true to allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF6D003B),
          title: Text('උදව්', style: GoogleFonts.notoSerifSinhala(fontSize: 14)),
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/background.jpg', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.0),
                color: Colors.transparent, // Set background color to transparent
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.amber),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'ඇප් එක හරියට භාවිතා කරන්නෙ කොහොමද?',
                          style: GoogleFonts.notoSerifSinhala(
                              fontSize: 16.0,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'ඇප් එක ආරම්භ කිරීමට ප්‍රථමයෙන් ඔබගේ අන්තර්ජාල සම්බන්ධතාව දෙවරක් පරීක්ශාකර බලන්න',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                            Text(
                              'ලිත භාවිතා කිරීමේදි එහි ඇති Calender එකේ නිවාඩු දින මත ක්ලික් කිරීමෙන් නිවාඩු දින පිලිබඳ වැඩිවිස්තර බලන්න පුලුවන්',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                            Text(
                              'ලිත් Screen එක Scroll කිරීම මගින් තොරතුරු බැලිය හැකිය',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
    
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.amber),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'හෙල Ai පිලිබඳ සහ භාවිතය ගැන',
                          style: GoogleFonts.notoSerifSinhala(
                              fontSize: 16.0,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'හෙල Ai යනු LankaTech Innovation මගින් 100% ලාංකිකව සවිබල ගන්වන Chat Bot එකකි',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                            Text(
                              'හෙල Ai භාවිතා කිරීමේදී ඔබගේ අන්තර්ජාල සම්බන්දතාව on එකේ තිබිය යුතුයි',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.amber),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'නැකැත් ඇප් නිර්මාණ දායකත්වය',
                          style: GoogleFonts.notoSerifSinhala(
                              fontSize: 16.0,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: const Color.fromARGB(255, 255, 255, 255)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              'නිර්මාතෘ : P.W නිමන්ත පෙරේරා',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'ග්‍රැෆික් නිර්මාණය : සංජන රනවීර',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              'දත්ත ඇතුලත් කිරීම : P.W නිමන්තිකා පෙරේරා',
                              style: GoogleFonts.notoSerifSinhala(
                                  fontSize: 14.0,
                                  color:
                                      const Color.fromARGB(255, 175, 175, 175)),
                            ),
                          ],
                        ),
                      ),
                    ),
    
                    SizedBox(height: 40.0),
    
                    // Social Media Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .blue, // Change the background color as needed
                            shape: CircleBorder(), // Make it a circle
                            padding: EdgeInsets.all(
                                2), // Adjust the padding as needed
                          ),
                          onPressed: () {
                            // Handle Facebook icon press
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.facebook,
                                  color: Colors
                                      .white), // Change icon color as needed
                              onPressed: () {
                                // Handle Facebook icon press
                                _launchURL('https://web.facebook.com/profile.php?id=100090771846367&mibextid=ZbWKwL&_rdc=1&_rdr');
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Add some space between buttons
    
                        // Repeat the structure for Twitter and Instagram buttons
    
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color.fromARGB(255, 0, 177, 74), // Change the background color as needed
                            shape: CircleBorder(), // Make it a circle
                            padding: EdgeInsets.all(
                                2), // Adjust the padding as needed
                          ),
                          onPressed: () {
                           
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.whatsapp,
                                  color: Colors
                                      .white), // Change icon color as needed
                              onPressed: () {
                                // Handle Twitter icon press
                                 _launchURL('https://api.whatsapp.com/send?phone=94762938664&text=%E0%B7%84%E0%B7%8F%E0%B6%BA%E0%B7%92%20%E0%B6%B8%E0%B6%B8%20%E0%B6%B1%E0%B7%90%E0%B6%9A%E0%B7%90%E0%B6%AD%E0%B7%8A%20App%20%E0%B6%91%E0%B6%9A%E0%B7%99%E0%B6%B1%E0%B7%8A%20%E0%B6%86%E0%B7%80%E0%B7%99'); _launchURL('https://api.whatsapp.com/send?phone=94762938664&text=%E0%B7%84%E0%B7%8F%E0%B6%BA%E0%B7%92%20%E0%B6%B8%E0%B6%B8%20%E0%B6%B1%E0%B7%90%E0%B6%9A%E0%B7%90%E0%B6%AD%E0%B7%8A%20App%20%E0%B6%91%E0%B6%9A%E0%B7%99%E0%B6%B1%E0%B7%8A%20%E0%B6%86%E0%B7%80%E0%B7%99');
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 16), // Add some space between buttons
    
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors
                                .purple, // Change the background color as needed
                            shape: CircleBorder(), // Make it a circle
                            padding: EdgeInsets.all(
                                2), // Adjust the padding as needed
                          ),
                          onPressed: () {
                            // Handle Instagram icon press
                          },
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(FontAwesomeIcons.globe,
                                  color: Colors
                                      .white), // Change icon color as needed
                              onPressed: () {
                               _launchURL('https://react-app-f8b50.web.app/');
                              },
                            ),
                          ),
                        ),
                        // Add more social media buttons as needed
                      ],
                    )
    
                    // Add more help topics as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

_launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


class HelpTopicCard extends StatelessWidget {
  final String title;
  final String description;

  const HelpTopicCard(this.title, this.description);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(title, style: TextStyle(fontSize: 16.0)),
        subtitle: Text(description),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Help(),
  ));
}
