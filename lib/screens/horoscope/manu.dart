import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}



class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Color(0xFF6D003B),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'වේලාවන් බැලීම සඳහා රු. 1500/=ක මුදලක් අයකරන බව කරුණාවෙන් සලකන්න. කරුණාකර ගෙවීම සමඟ ඉදිරියට යන්න.',
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: Text('Proceed to Payment'),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  // Close the dialog box
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'වේලාවන්\n බැලීම',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 14.0,
                        ), // Center the text
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.amber[800],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'පොරොන්දම් ගැලපීම',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 14.0,
                        ), // Center the text
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.amber[800],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16), // Adding space between rows

            // Add additional rows if needed
          ],
        ),
      ),
    );
  }
}
