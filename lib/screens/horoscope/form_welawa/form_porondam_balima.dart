import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:aurudu_nakath/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';

class FormPorondam extends StatefulWidget {
  const FormPorondam({Key? key}) : super(key: key);

  @override
  State<FormPorondam> createState() => _FormWelaawaState();
}

class _FormWelaawaState extends State<FormPorondam> {
  TimeOfDay selectedTime = TimeOfDay.now();
  // bool isMale = false;
  // bool isFemale = false;
  String? selectedDistrict;
  String? selectedDistrict2;
  TextEditingController selectedName = TextEditingController();
  TextEditingController selectedName2 = TextEditingController();
  TextEditingController additionalInfo = TextEditingController();

  DateTime selectedDate = DateTime.now();
  DateTime selectedDate2 = DateTime.now();
  // Initial date

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

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

  String filePath = '';
  String filePath2 = '';

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'png'],
      );
    } catch (error) {
      // Handle potential errors during file picking
      print("Error picking file: $error");
    }
  }

  String mimeTypeLookup(String fileName) {
    final mimeTypeResolver = MimeTypeResolver();
    return mimeTypeResolver.lookup(fileName) ?? 'application/octet-stream';
  }

  Future<void> _uploadFile(String filePath) async {
    if (filePath != null && File(filePath).existsSync()) {
      File file = File(filePath);
      String fileName = file.uri.pathSegments.last; // Extract filename

      firebase_storage.Reference reference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('your_storage_path/$fileName'); // Create a reference

      final metadata = firebase_storage.SettableMetadata(
        contentType:
            mimeTypeLookup(fileName), // Set content type based on filename
      );

      try {
        await reference.putFile(file, metadata);
        print('File uploaded successfully!');
      } catch (e) {
        print('Error uploading file: $e');
        // Handle errors appropriately, e.g., show a snackbar or retry
      }
    } else {
      print('No file selected or file does not exist!');
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
            'පොරොන්දම් පෝරමය',
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
                      labelText: 'පිරිමි පාර්ශවයේ සම්පූර්ණ නම (සිංහලෙන්)',
                      labelStyle: GoogleFonts.notoSerifSinhala(
                        fontSize: 12,
                      ), // Adjust font size here
                      prefixIcon: Icon(
                          Icons.male), // Changed to prefixIcon for alignment
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'සම්පූර්ණ නම අවශ්‍යයි';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),

                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "උපන් දිනය (පිරිමි)",
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 12,
                        ),
                      )),
// ...

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            selectedDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(selectedDate.toLocal())
                                : 'Add birthday',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),

                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'උපන් දිස්ත්‍රික්කය (පිරිමි)',
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

                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "කේන්දරය (පිරිමි) (පැහැදිලි ජායාරූප හෝ PDF ඇතුලත් කරන්න)",
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 12,
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'තෝරාගත් ගොනුව $filePath',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // To make the Row take minimum space
                          children: [
                            Icon(Icons
                                .file_upload), // Replace with the desired icon
                            SizedBox(
                                width:
                                    8), // Adjust spacing between icon and text
                            Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: selectedName2,
                    key: Key('unique_key2'),
                    keyboardType: TextInputType.name,
                    style: TextStyle(
                      fontSize: 12, // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(), // Added border
                      labelText: 'ගැහැනු පාර්ශවයේ සම්පූර්ණ නම (සිංහලෙන්)',
                      labelStyle: GoogleFonts.notoSerifSinhala(
                        fontSize: 12,
                      ), // Adjust font size here
                      prefixIcon: Icon(
                          Icons.female), // Changed to prefixIcon for alignment
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'සම්පූර්ණ නම අවශ්‍යයි';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "උපන් දිනය (ගැහැනු)",
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 12,
                        ),
                      )),
// ...

                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 10),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          child: Text(
                            selectedDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(selectedDate.toLocal())
                                : 'Add birthday',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        SizedBox(width: 20),
                        IconButton(
                          onPressed: () => _selectDate(context),
                          icon: Icon(Icons.calendar_month),
                        ),
                      ],
                    ),
                  ),

                  DropdownButtonFormField<String>(
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(
                          255, 0, 0, 0), // Adjust text size that user inputs
                    ),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'උපන් දිස්ත්‍රික්කය (ගැහැනු)',
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
                        selectedDistrict2 = value;
                      });
                    },
                    value: selectedDistrict2,
                  ),
                  SizedBox(height: 20.0),

                  SizedBox(
                      height:
                          20.0), // Increased space for better visual separation

                  // ListTile(
                  //   leading: Icon(Icons.access_time),
                  //   title: Text('උපන් වේලාව',
                  //       style: GoogleFonts.notoSerifSinhala(fontSize: 12)),
                  //   subtitle: Text(selectedTime.format(context)),
                  //   onTap: () => _selectTime(context),
                  // ),
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

                  Container(
                      margin: EdgeInsets.only(top: 10, bottom: 5),
                      child: Text(
                        "කේන්දරය (ගැහැනු) (පැහැදිලි ජායාරූප හෝ PDF ඇතුලත් කරන්න)",
                        style: GoogleFonts.notoSerifSinhala(
                          fontSize: 12,
                        ),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            'තෝරාගත් ගොනුව $filePath',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _pickFile,
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // To make the Row take minimum space
                          children: [
                            Icon(Icons
                                .file_upload), // Replace with the desired icon
                            SizedBox(
                                width:
                                    8), // Adjust spacing between icon and text
                            Text(''),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.start, // Align to the start
                  //   children: [
                  //     Expanded(
                  //       // Using Expanded for better alignment and spacing
                  //       child: ListTile(
                  //         leading: Checkbox(
                  //           value: isMale,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               isMale = value ?? false;
                  //               if (isMale) isFemale = false;
                  //             });
                  //           },
                  //         ),
                  //         title: Text(
                  //           'පිරිමි',
                  //           style: GoogleFonts.notoSerifSinhala(fontSize: 12),
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: ListTile(
                  //         leading: Checkbox(
                  //           value: isFemale,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               isFemale = value ?? false;
                  //               if (isFemale) isMale = false;
                  //             });
                  //           },
                  //         ),
                  //         title: Text(
                  //           'ගැහැනු',
                  //           style: GoogleFonts.notoSerifSinhala(fontSize: 12),
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
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
   if (selectedName.text.isEmpty) {
    _showErrorDialog("Please enter a name.");
    return;
  }

  if (selectedTime == null) {
    _showErrorDialog("Please select a time.");
    return;
  }

  if (selectedDistrict == null) {
    _showErrorDialog("Please select a district.");
    return;
  }

  if (selectedName2.text.isEmpty) {
    _showErrorDialog("Please enter the second name.");
    return;
  }

  if (selectedDistrict2 == null) {
    _showErrorDialog("Please select the second district.");
    return;
  
    } else {
      try {
        // Upload the first file
        await _uploadFile(filePath);

        // Upload the second file
        await _uploadFile(filePath2);
        // Access the Firestore instance
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Create a reference to a new document
        CollectionReference formCollection =
            firestore.collection('පොරොන්දම්_බැලීමට_user_details');

        // Add data to the document
        await formCollection.add({
          'නම_පුරුශ': selectedName.text,
          'උපන්_දිස්ත්‍රික්කය_පුරුශ': selectedDistrict,
          'උපන්_දිනය_පුරුශ': selectedDate,
          'නම_ස්ත්‍රී': selectedName2.text,
          'උපන්_දිස්ත්‍රික්කය_ස්ත්‍රී': selectedDistrict2,
          'උපන්_දිනය_ස්ත්‍රී': selectedDate2,
          'වැඩි_විස්තර': additionalInfo.text,
          // 'ස්ත්‍රී_පුරුශ': isMale ? 'Male' : (isFemale ? 'Female' : ''),
        });

        // Display a success message using showDialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Color.fromARGB(255, 0, 241, 169),
              title: Text(
                "Success",
                style: TextStyle(
                  color: Color(0xFF585858),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Container(
                child: Column(
                  children: [
                    Lottie.network(
                        'https://lottie.host/a97e028a-48dd-4549-8f53-68060d76c5b7/Fe6RAnfouo.json',
                        height: 200,
                        width: 200,
                        repeat: false),
                    Center(
                      child: Text(
                        "ඔබගේ තොරතුරු සාර්ථකව ඉදිරිපත් කර ඇත. ඔබට දින 1,2 ත් අතර කාලය තුල ඔබගේ වේලාපත බැලීම සඳහා කේතයක් WhatsApp හා ඊමේල් මාර්ගයෙන් අප විසින් ඔබට ලැබීමට සලස්වමු. ඔබට ස්තූතී නැකැත් App හා නොබැඳිව රැදී සිටින්න.",
                        style: GoogleFonts.notoSerifSinhala(
                          color: Color.fromARGB(255, 255, 255, 255),
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
                    // Add any action you want here, like navigating to another screen
                    // Clear the form fields
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
                    style: TextStyle(
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

void main() {
  runApp(FormPorondam());
}
