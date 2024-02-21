import 'dart:ffi';
import 'dart:math';

import 'package:aurudu_nakath/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      fontSize: 12, // Adjust text size that user inputs
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
                      fontSize: 12,
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
                      fontSize: 12, // Adjust text size that user inputs
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
                        primary: Colors.teal,
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

        // Create a reference to a new document
        CollectionReference formCollection =
        firestore.collection('welawa_user_details');

        
        // Add data to the document
        await formCollection.add({
          'name': selectedName.text,
          'district': selectedDistrict,
          'time': selectedTime.format(context),
          'additionalInfo': additionalInfo.text,
          'Gender': isMale ? 'Male' : (isFemale ? 'Female' : ''),
        });

        // Display a success message using showDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.green[400],
              title: Text(
                "Success",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(
                "Your form has been submitted successfully!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    // Add any action you want here, like navigating to another screen
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

        // Clear the form fields
        selectedName.clear();
        additionalInfo.clear();
        selectedTime = TimeOfDay.now();
        selectedDistrict = null;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return HomeScreen();
            },
          ),
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


void main() {
  runApp(FormWelaawa());
}
