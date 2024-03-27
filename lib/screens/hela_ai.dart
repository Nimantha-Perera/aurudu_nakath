import 'package:aurudu_nakath/Ads/init_ads.dart';
import 'package:aurudu_nakath/Image_chache_Save/img_chanche.dart';
import 'package:aurudu_nakath/User_backClicked/back_clicked.dart';
import 'package:aurudu_nakath/screens/Results_Screens/result_screen_porondam.dart';
import 'package:aurudu_nakath/screens/Results_Screens/result_screen_welawa.dart';
import 'package:aurudu_nakath/screens/aurudu_nakath.dart';
import 'package:aurudu_nakath/screens/help.dart';
import 'package:aurudu_nakath/screens/nakath_sittuwa.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

List<String> keyWords_maru_sitna_disawa = [
  'maru sitina disawa',
  'mru sitina disawa',
  'මරු සිටින දිශාව',
  "අද මරු සිටින දිශාව"
];
List<String> bad_words = [
  'හුත්තෝ',
  'පකෝ',
  'පකයා',
  'හුකන්නා',
  'fuck',
  'sex',
  'xxx'
];
List<String> Rahu_kalaya = [
  'අද රාහු කාලය',
  'රාහුකාලය',
  'රාහු කාලය',
  'raahukalaya',
  'rahu kalaya',
  'ada rahukalaya'
];

class HelaChatAI extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<HelaChatAI> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool isSendButtonEnabled = false;


  InterstitialAdManager interstitialAdManager = InterstitialAdManager();

  void _handleSubmitted(String text) {
    // Clear the text input field
    _textController.clear();

    // Add user message to the list
    _addMessage(text, true);

    // Convert user input to lowercase for case-insensitive matching
    String lowercaseText = text.toLowerCase();

    if (bad_words.contains(lowercaseText)) {
      String defaultResponse = "සමාවෙන්න, වචන භාවිතා කිරීමේදී පරිස්සම් වන්න.";

      Future.delayed(Duration(seconds: 1), () {
        _simulateTyping(defaultResponse, false);
      });
    }

    // Check if the user entered "රාහු කාලය"
    else if (Rahu_kalaya.contains(lowercaseText)) {
      // Get the current day of the week in Sinhala
      DateTime now = DateTime.now();
      String currentDayInSinhala = _getSinhalaDayOfWeek(now.weekday);
      print('Numeric Day of the Week: $currentDayInSinhala');

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child('රාහු_කාලය');

      // Perform a database lookup for the user-entered text
      databaseReference
          .child(currentDayInSinhala)
          .once()
          .then((DatabaseEvent event) {
        // Handle the snapshot data
        if (event.snapshot.value != null) {
          // Get the response from the database
          String aiResponse = event.snapshot.value.toString();

          // Simulate typing effect for 1 second
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(aiResponse, false);
          });
        } else {
          // If specific day data not found, try a general lookup
          databaseReference.once().then((DatabaseEvent nestedEvent) {
            Map<dynamic, dynamic> data =
                nestedEvent.snapshot.value as Map<dynamic, dynamic>;

            if (data != null) {
              data.forEach((key, value) {
                if (value is Map && value.containsKey(currentDayInSinhala)) {
                  // If nested section found, get the corresponding value
                  String nestedResponse = value[currentDayInSinhala].toString();

                  // Simulate typing effect for 1 second
                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(nestedResponse, false);
                  });
                } else {
                  // If no nested sections found, provide a default response
                  String defaultResponse =
                      "සමාවෙන්න, ඇතුළත් කළ පෙළ සඳහා මට කිසිදු තොරතුරක් සොයාගත නොහැකි විය. කරුනාකර යෝජනා (Suggetions) භාවිතා කරන්න";

                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(defaultResponse, false);
                  });
                }
              });
            } else {
              // Provide a default response if no information is found
              String defaultResponse =
                  "Sorry, I couldn't find any information for the entered text.";
              _simulateTyping(defaultResponse, false);
            }
          }).catchError((error) {
            // Handle any errors during the general database operation
            print("Error: $error");

            // Provide an error response
            String errorResponse =
                "An error occurred while processing your request.";
            _simulateTyping(errorResponse, false);
          });
        }
      }).catchError((error) {
        // Handle any errors that may occur during the specific day database operation
        print("Error: $error");

        // Provide an error response
        String errorResponse =
            "An error occurred while processing your request.";
        _simulateTyping(errorResponse, false);
      });

      return; // Exit the function after processing the specific case

      // මරු සිටින දිශාව ද බැලීම
    } else if (keyWords_maru_sitna_disawa.contains(lowercaseText)) {
      // Get the current day of the week in Sinhala
      DateTime now = DateTime.now();
      String currentDayInSinhala = _getSinhalaDayOfWeek(now.weekday);
      print('Numeric Day of the Week: $currentDayInSinhala');

      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child('මරු_සිටින_දිශාව');

      // Perform a database lookup for the user-entered text
      databaseReference
          .child(currentDayInSinhala)
          .once()
          .then((DatabaseEvent event) {
        // Handle the snapshot data
        if (event.snapshot.value != null) {
          // Get the response from the database
          String aiResponse = event.snapshot.value.toString();

          // Simulate typing effect for 1 second
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(aiResponse, false);
          });
        } else {
          // If specific day data not found, try a general lookup
          databaseReference.once().then((DatabaseEvent nestedEvent) {
            Map<dynamic, dynamic> data =
                nestedEvent.snapshot.value as Map<dynamic, dynamic>;

            if (data != null) {
              data.forEach((key, value) {
                if (value is Map && value.containsKey(currentDayInSinhala)) {
                  // If nested section found, get the corresponding value
                  String nestedResponse = value[currentDayInSinhala].toString();

                  // Simulate typing effect for 1 second
                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(nestedResponse, false);
                  });
                } else {
                  // If no nested sections found, provide a default response
                  String defaultResponse =
                      "සමාවෙන්න, ඇතුළත් කළ පෙළ සඳහා මට කිසිදු තොරතුරක් සොයාගත නොහැකි විය. කරුනාකර යෝජනා (Suggetions) භාවිතා කරන්න";

                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(defaultResponse, false);
                  });
                }
              });
            } else {
              // Provide a default response if no information is found
              String defaultResponse =
                  "Sorry, I couldn't find any information for the entered text.";
              _simulateTyping(defaultResponse, false);
            }
          }).catchError((error) {
            // Handle any errors during the general database operation
            print("Error: $error");

            // Provide an error response
            String errorResponse =
                "An error occurred while processing your request.";
            _simulateTyping(errorResponse, false);
          });
        }
      }).catchError((error) {
        // Handle any errors that may occur during the specific day database operation
        print("Error: $error");

        // Provide an error response
        String errorResponse =
            "An error occurred while processing your request.";
        _simulateTyping(errorResponse, false);
      });

      return; // Exit the function after processing the specific case

      //Check nakath balima hoo porondam galapaima
    } else if ("කෝඩ් ඇතුලත් කිරීම" == lowercaseText) {
      String defaultResponse =
          "කරුණාකර ඔබට අප විසින් ලබාදුන් (උදා: #123456) කේතය ඇතුලත් කරන්න.";

      Future.delayed(Duration(seconds: 1), () {
        _simulateTyping(defaultResponse, false);
      });
    } else if (lowercaseText.startsWith("#")) {
  // Extract the user-entered code excluding the "#" symbol
  String userEnteredCode = lowercaseText.substring(1);

  FirebaseFirestore.instance
      .collection('nakath_welawa_results')
      .where(FieldPath.documentId, isEqualTo: "#" + userEnteredCode)
      .get()
      .then((QuerySnapshot welawaSnapshot) {
    if (welawaSnapshot.docs.isNotEmpty && userEnteredCode.length >= 5 ) {
      // Document with the matching ID exists in 'nakath_welawa_results' collection and 5th character is '5'
      String welawaResponse = "ඔබගේ කේතය නිවැරදී";
      Future.delayed(Duration(seconds: 1), () {
        _simulateTyping(welawaResponse, false);
      });

      // Navigate to ResultsWelaawa
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsWelaawa(data: "#" + userEnteredCode),
        ),
      );
    } else {
      // Check 'nakath_porondam_results' if the 5th character is '6'
      FirebaseFirestore.instance
          .collection('nakath_porondam_results')
          .where(FieldPath.documentId, isEqualTo: "#" + userEnteredCode)
          .get()
          .then((QuerySnapshot porondamSnapshot) {
        if (porondamSnapshot.docs.isNotEmpty && userEnteredCode.length >= 6) {
          // Document with the matching ID exists in 'nakath_porondam_results' collection and 5th character is '6'
          String porondamResponse = "ඔබගේ කේතය නිවැරදී";
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(porondamResponse, false);
          });


          print("Entered User Code: Now Navigate to ResultsPorondam");

          // Navigate to ResultsPorondam
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsPorondam(data: "#" + userEnteredCode),
            ),
          );
        } else {
          // Document with the matching ID does not exist in either collection
          String notFoundResponse = "සමාවන්න, ඔබේ කේතයේ කිසියම් වැරැද්දක් ඇත කරුනාකර නිවැරදි කේතය පරීක්ශා කර ඇතුලත් කරන්න.";
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(notFoundResponse, false);
          });
        }
      });
    }
  });



      // හෑශ්ටැග් භාවිතයෙන් මාරු වීම
    } else if ("අවුරුදු නැකැත්" == lowercaseText) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return NakathSittuwa();
          },
        ),
      );
      String notFoundResponse =
              "අවුරුදු නැකැත් විවෘත කලා  ✔";
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(notFoundResponse, false);
          });
    } else if ("ලිත" == lowercaseText) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return AuruduNakathScreen();
          },
        ),
      );
      String notFoundResponse =
              "ලිත විවෘත කලා  ✔";
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(notFoundResponse, false);
          });
    } else if ("උදව්" == lowercaseText) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return Help();
          },
        ),
      );
      String notFoundResponse =
              "උදව් විවෘත කලා  ✔";
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(notFoundResponse, false);
          });
    } else {
      // Continue with the existing code for general cases
      DatabaseReference databaseReference =
          FirebaseDatabase.instance.reference().child('ai_messages');

      // Perform a database lookup for the user-entered text
      databaseReference.child(lowercaseText).once().then((DatabaseEvent event) {
        // Handle the snapshot data
        if (event.snapshot.value != null) {
          // Get the response from the database
          String aiResponse = event.snapshot.value.toString();

          // Simulate typing effect for 1 second
          Future.delayed(Duration(seconds: 1), () {
            _simulateTyping(aiResponse, false);
          });
        } else {
          // If no direct match found, check for nested sections
          databaseReference.once().then((DatabaseEvent nestedEvent) {
            Map<dynamic, dynamic> data =
                nestedEvent.snapshot.value as Map<dynamic, dynamic>;

            // Check for nested sections
            if (data != null) {
              data.forEach((key, value) {
                if (value is Map && value.containsKey(lowercaseText)) {
                  // If nested section found, get the corresponding value
                  String nestedResponse = value[lowercaseText].toString();
                  print("Nested Response: $nestedResponse");

                  // Simulate typing effect for 1 second
                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(nestedResponse, false);
                  });
                } else if (lowercaseText == ("ලග්න පලාපල")) {
                  String errorResponse =
                      "කරුනාකර ඔබට අවශ්‍ය ලග්නය සිංහලෙන් සදහන් කරන්න";
                  _simulateTyping(errorResponse, false);
                } else {
                  // If no nested sections found, provide a default response
                  String defaultResponse =
                      "සමාවෙන්න, ඇතුළත් කළ පෙළ සඳහා මට කිසිදු තොරතුරක් සොයාගත නොහැකි විය. කරුනාකර යෝජනා (Suggetions) භාවිතා කරන්න";

                  Future.delayed(Duration(seconds: 1), () {
                    _simulateTyping(defaultResponse, false);
                  });
                }
              });
            }
          });

          // If no data found in the database, provide a default response

          // Simulate typing effect for 1 second
        }
      }).catchError((error) {
        // Handle any errors that may occur during the database operation
        print("Error: $error");

        // Provide an error response
        String errorResponse =
            "An error occurred while processing your request.";
        _simulateTyping(errorResponse, false);
      });
    }
  }

  @override
  void initState() {
    super.initState();
 ImageUtils.precacheImage(context);
    interstitialAdManager.initInterstitialAd();
  }

  String _getSinhalaDayOfWeek(int dayOfWeek) {
    switch (dayOfWeek) {
      case DateTime.sunday:
        return "ඉරිදා";
      case DateTime.monday:
        return "සඳුදා";
      case DateTime.tuesday:
        return "අඟහරුවාදා";
      case DateTime.wednesday:
        return "බදාදා";
      case DateTime.thursday:
        return "බ්‍රහස්පතින්දා";
      case DateTime.friday:
        return "සිකුරාදා";
      case DateTime.saturday:
        return "සෙනසුරාදා";
      default:
        return "";
    }
  }

  void _simulateTyping(String message, bool isUser) {
    Future.delayed(Duration(seconds: 1), () {
      _addMessage(message, isUser);
    });
  }

  void _addMessage(String text, bool isUser) {
    ChatMessage message = ChatMessage(
      text: text,
      isUser: isUser,
    );

    setState(() {
      _messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BackButtonUtil.handleBackButton(interstitialAdManager!);

        return true; // Return true to allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'හෙල AI',
            style: GoogleFonts.notoSerifSinhala(
              fontSize: 14.0,
            ),
          ),
          centerTitle: true,
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFF6D003B),
        ),
        body: Stack(
          children: [
            // Background Image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/background_ai.png'), // Replace with your image asset path
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Column for chat interface
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return _messages[index];
                    },
                  ),
                ),
                Divider(height: 1.0),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                  ),
                  child: _buildTextComposer(),
                ),
              ],
            ),
            // Add your Stack children here if needed
          ],
        ),
      ),
    );
  }

  Widget _buildTextComposer() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text('Suggetions'),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    buildSuggestionButton(
                      "ආයුබෝවන්",
                    ),
                    buildSuggestionButton("කෝඩ් ඇතුලත් කිරීම"),
                    buildSuggestionButton("උදව්"),
                    buildSuggestionButton("අවුරුදු නැකැත්"),
                    buildSuggestionButton("අද රාහු කාලය"),
                    buildSuggestionButton("අද මරු සිටින දිශාව"),
                    buildSuggestionButton("ලිත"),
                    buildSuggestionButton("ලග්න පලාපල"),
                    buildSuggestionButton("අද රාහු කාලය"),
                    
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
  margin: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Row(
    children: <Widget>[
      Flexible(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _textController,
            onChanged: (text) {
              // Update the state to enable/disable the button based on whether there is text
              setState(() {
                isSendButtonEnabled = text.isNotEmpty;
              });
            },
            onSubmitted: _handleSubmitted,
            style: TextStyle(fontSize: 12),
            decoration: InputDecoration(
              hintText: "ඔබට අවශ්‍ය විස්තරය කෙටියෙන් මෙහි ලියන්න",
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.send),
                onPressed: isSendButtonEnabled
                    ? () => _handleSubmitted(_textController.text)
                    : null, // Disable the button if isSendButtonEnabled is false
              ),
            ),
          ),
        ),
      ),
    ],
  ),
),

      ],
    );
  }

Widget buildSuggestionButton(String suggestion) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    child: ElevatedButton(
      onPressed: () {
        _textController.text = suggestion;
        _handleSubmitted(suggestion);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 255, 217, 0), // Change the button color here
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Change the border radius here
        ),
      ),
      child: Text(suggestion,style: GoogleFonts.notoSerifSinhala(fontSize: 12,color: const Color.fromARGB(255, 77, 77, 77)),),
    ),
  );
}
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isUser)
            Text(
              "ඔබ",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: Stack(
              children: [
                // Chat Bubble
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Colors.amber
                        : Color.fromARGB(255, 253, 102, 43),
                    borderRadius: BorderRadius.circular(8.0),
                    // Add elevation for a slight shadow
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    text,
                    style: GoogleFonts.notoSerifSinhala(
                      fontSize: 12.0,
                      color: isUser
                          ? Color.fromARGB(255, 255, 255, 255)
                          : Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
                // Triangle Indicator
                Positioned(
                  bottom: 0,
                  child: CustomPaint(
                    painter: TrianglePainter(isUser
                        ? Colors.amber
                        : const Color.fromARGB(255, 253, 102, 43)),
                    size: Size(10.0, 10.0),
                  ),
                ),
              ],
            ),
          ),
          if (!isUser)
            Text(
              "හෙල AI",
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
        ],
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final Path path = Path();

    path.moveTo(0, 0);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
