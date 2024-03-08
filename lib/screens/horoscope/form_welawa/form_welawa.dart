import 'dart:ffi';
import 'dart:math';

import 'package:aurudu_nakath/screens/home.dart';
import 'package:aurudu_nakath/screens/horoscope/form_welawa/form_porondam_balima.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:mailer/mailer.dart' as mailer;

class FormWelaawa extends StatefulWidget {
  const FormWelaawa({Key? key}) : super(key: key);

  @override
  State<FormWelaawa> createState() => _FormWelaawaState();
}

class _FormWelaawaState extends State<FormWelaawa> {
  TimeOfDay selectedTime = TimeOfDay.now();
  bool isMale = false;
  bool isFemale = false;
  String? selectedDistrict;
  TextEditingController selectedName = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();
  TextEditingController email = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  static const sriLankaDistricts = [
    'අම්පාර',
    'අනුරාධපුර',
    'බදුල්ල',
    'බට්ටිකාලුව',
    'කොළඹ',
    'ගාල්ල',
    'ගම්පහ',
    'හම්බන්තොට',
    'යාපනය',
    'කළුතර',
    'මහනුවර',
    'කෑගල්ල',
    'කිලිනොච්චි',
    'කුරුණෑගල',
    'මන්නාරම',
    'මාතලේ',
    'මාතර',
    'මොනරාගල',
    'මුල්ලයිටිවු',
    'නුවර එළිය',
    'පොළොන්නාරුව',
    'පුත්තලම',
    'රත්නපුර',
    'ත්‍රිකුනාමලය',
    'වවුනියා',
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'වෙලාව පෝරමය',
            style: GoogleFonts.notoSerifSinhala(
              fontSize: 14.0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF6D003B),
        ),
        body: SingleChildScrollView(
          // To ensure the form is scrollable on small devices.
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: selectedName,
                    key: Key('unique_key'),
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontSize: 15, // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Added border
                      labelText: 'සම්පූර්ණ නම (සිංහලෙන්)',
                      labelStyle: GoogleFonts.notoSerifSinhala(
                        fontSize: 12,
                      ), // Adjust font size here
                      prefixIcon: Icon(
                          Icons.person), // Changed to prefixIcon for alignment
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'සම්පූර්ණ නම අවශ්‍යයි';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),

                  SizedBox(
                      height:
                          20.0), // Increased space for better visual separation
                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'උපන් දිස්ත්‍රික්කය',
                      labelStyle: GoogleFonts.notoSerifSinhala(
                          fontSize: 12), // Adjust font size here
                      prefixIcon: Icon(Icons.map), // Updated icon
                    ),
                    items: sriLankaDistricts
                        .map((district) => DropdownMenuItem(
                              value: district,
                              child: Text(district),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDistrict = value;
                      });
                    },
                    value: selectedDistrict,
                  ),
                  SizedBox(height: 20.0),
                  ListTile(
                    leading: Icon(Icons.access_time),
                    title: Text('උපන් වේලාව',
                        style: GoogleFonts.notoSerifSinhala(fontSize: 12)),
                    subtitle: Text(selectedTime.format(context)),
                    onTap: () => _selectTime(context),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    maxLines: 4,
                    controller: additionalInfo,
                    key: Key('unique_2key'),
                    style: TextStyle(
                      fontSize: 15, // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Added border
                      labelText: 'වැඩි විස්තර (සිංහලෙන්)',

                      labelStyle: GoogleFonts.notoSerifSinhala(
                          fontSize: 12), // Adjust font size here
                      prefixIcon: Icon(
                          Icons.note), // Changed to prefixIcon for alignment
                    ),
                  ),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.start, // Align to the start
                    children: [
                      Expanded(
                        // Using Expanded for better alignment and spacing
                        child: ListTile(
                          leading: Checkbox(
                            value: isMale,
                            onChanged: (value) {
                              setState(() {
                                isMale = value ?? false;
                                if (isMale) isFemale = false;
                              });
                            },
                          ),
                          title: Text(
                            'පිරිමි',
                            style: GoogleFonts.notoSerifSinhala(fontSize: 12),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Checkbox(
                            value: isFemale,
                            onChanged: (value) {
                              setState(() {
                                isFemale = value ?? false;
                                if (isFemale) isMale = false;
                              });
                            },
                          ),
                          title: Text(
                            'ගැහැනු',
                            style: GoogleFonts.notoSerifSinhala(fontSize: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: email,
                    key: Key('unique_key3'),
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontSize: 15, // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Added border
                      labelText: 'ඊමේල් ලිපිනයක් ඇතුලත් කරන්න.',
                      labelStyle: GoogleFonts.notoSerifSinhala(
                        fontSize: 12,
                      ), // Adjust font size here
                      prefixIcon: Icon(
                          Icons.email), // Changed to prefixIcon for alignment
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ඊමේල් ලිපිනයක් අවශ්‍යයි';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
            
                  SizedBox(height: 20.0),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle form submission
                        _submitForm();
                      },
                      child: Text(
                        'යවන්න',
                        style: GoogleFonts.notoSerifSinhala(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 50, vertical: 15), // More padding
                        textStyle: TextStyle(fontSize: 16), // Bigger text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (selectedName == null) {
      _showErrorDialog("කරුනාකර නම ඇතුලත් කරන්න.");
    } else if (selectedTime == null) {
      _showErrorDialog("කරුනාකර උපන් වේලාව ඇතුලත් කරන්න.");
    } else if (selectedDistrict == null) {
      _showErrorDialog("කරුනාකර උපන් දිස්ත්‍රික්කය ඇතුලත් කරන්න.");
    } else if (isMale == false && isFemale == false) {
      _showErrorDialog("කරුනාකර ගැහැනු/පිරිමි ද යන්න සඳහන් කරන්න.");
    } else {
      try {
        // Access the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;
         // Generate a random integer with a length of 6
        int randomNumber = Random().nextInt(99999); // 6-digit number

        // Add '#' at the beginning
        String result = '#$randomNumber';

        // Create a reference to a new document
        CollectionReference formCollection =
            firestore.collection('welawa_user_details');
          String username = selectedName.text;
        // Add data to the document
        await formCollection.add({
          'නම': selectedName.text,
          'උපන්_දිස්ත්‍රික්කය': selectedDistrict,
          'උපන්_වෙලාව': selectedTime.format(context),
          'වැඩි_විස්තර': additionalInfo.text,
          'ස්ත්‍රී_පුරුශ': isMale ? 'Male' : (isFemale ? 'Female' : ''),
          'ර්‍ර්මේල්': email.text,
          'හෑශ්_කේතය': result
        });
     String recipientEmail = email.text;
        String emailSubject = 'හෙලෝ, ඔබගේ නැකැත් App පොරොන්දම් හෑශ් කේතය';
        String emailBody = '$username ඔබගේ නැකැත් App පොරොන්දම් බැලීම සඳහා  අදාල වන හෑශ් කේතය වන්නෙ: $result';

        sendEmail(recipientEmail, emailSubject, emailBody);

        // Access the Firestore instance
        FirebaseFirestore firestore2 = FirebaseFirestore.instance;

        // Reference to nakath_porondam_results collection and set document ID
        DocumentReference resultDocument =
            firestore.collection('nakath_welawa_results').doc(result);
        // Create an empty Map or add your fields accordingly
        Map<String, dynamic> emptyData = {};

        // Add an empty document to the 'nakath_porondam_results' collection
        await resultDocument.set(emptyData);
    // Display a success message using showDialog
    showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              backgroundColor: Colors.white, // Set the background color
              title: Text(
                "Success",
                style: TextStyle(
                  color: Color(0xFF585858),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                width: 300,
                height: 290, // Set the width of the content container
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/a97e028a-48dd-4549-8f53-68060d76c5b7/Fe6RAnfouo.json',
                      height: 150, // Set the height of the Lottie animation
                      width: 150, // Set the width of the Lottie animation
                      repeat: false,
                    ),
                    Center(
                      child: Text(
                        "ඔබගේ තොරතුරු සාර්ථකව ඉදිරිපත් කර ඇත. WhatsApp හෝ විද්‍යුත් තැපෑල හරහා ඔබගේ හමුවීම් විස්තර සහිත තහවුරු කිරීමේ කේතයක් ඔබට ලැබෙනු ඇත. ඔබට එය නොලැබුනේ නම් කරුණාකර අපට දැනුම් දෙන්න.",
                        style: GoogleFonts.notoSerifSinhala(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    selectedName.clear();
                    additionalInfo.clear();
                    selectedTime = TimeOfDay.now();
                    selectedDistrict = null;

                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  child: Text(
                    "හරි",
                    style: GoogleFonts.notoSerifSinhala(
                      color: Color(0xFFFFBB00),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );

      } catch (error) {
        // Handle errors
        print('Error submitting form data: $error');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red[400],
          title: Text(
            "Error",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

void sendEmail(String recipientEmail, String subject, String body) async {
  // Replace these with your email configuration
  final smtpServer = gmail('nakathapp@gmail.com', 'ictd xqeg sshg mjwt');

  // Create a message
  final message = mailer.Message()
    ..from = mailer.Address('nakathapp@gmail.com', 'නැකැත් App')
    ..recipients.add(recipientEmail)
    ..subject = subject
    ..text = body;

  try {
    // Send the email
    final sendReport = await mailer.send(message, smtpServer);

    print('Message sent: ' + sendReport.toString());
  } catch (e) {
    print('Error sending email: $e');
  }
}

void main() {
  runApp(FormWelaawa());
}
