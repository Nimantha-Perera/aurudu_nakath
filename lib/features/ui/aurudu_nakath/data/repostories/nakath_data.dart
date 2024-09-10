import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NakathData extends StatelessWidget {
  const NakathData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DatabaseEvent>(
      stream: FirebaseDatabase.instance
          .ref()
          .child('aurudu_nakath_sittuwa')
          .onValue,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data?.snapshot.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
        final sortedList = data.entries.toList()
          ..sort((a, b) => b.value['index_no'].compareTo(a.value['index_no']));

        final filteredList = sortedList.where((entry) {
          int index = entry.value['index_no'];
          return index >= 1 && index <= 12;
        }).toList();

        return ListView.builder(
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final entry = filteredList[index];
            final title = entry.value['nakatha'];
            final subtitle = entry.value['wistharaya'];

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  leading: Icon(Icons.schedule, color: Colors.amber),
                  title: Text(
                    title,
                    style: GoogleFonts.notoSerifSinhala(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    subtitle,
                    style: GoogleFonts.notoSerifSinhala(fontSize: 13),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
