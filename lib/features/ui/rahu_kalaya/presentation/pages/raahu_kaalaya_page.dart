import 'package:aurudu_nakath/features/ui/rahu_kalaya/data/modals/raahu_kaalaya_model.dart';
import 'package:aurudu_nakath/features/ui/rahu_kalaya/data/modals/raahu_kaalaya_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RaahuKaalaya extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle back button with ad display logic
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xFFFABC3F),
          centerTitle: true,
          title: Text(
            'රාහු කාලය',
            style: GoogleFonts.notoSerifSinhala(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaahuKaalayaView(),
        ),
      ),
    );
  }
}

class RaahuKaalayaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RaahuKaalayaModel>>(
      future: RaahuKaalayaViewModel().fetchRaahuKaalayaData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        return RaahuKaalayaCardList(rows: snapshot.data!);
      },
    );
  }
}

class RaahuKaalayaCardList extends StatelessWidget {
  final List<RaahuKaalayaModel> rows;

  RaahuKaalayaCardList({required this.rows});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) {
        final data = rows[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              leading: Icon(
                Icons.calendar_today, // Replace with an appropriate icon
                color: Color(0xFFFABC3F),
                size: 20,
              ),
              title: Text(
                data.dawasa,
                style: GoogleFonts.notoSerifSinhala(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                data.welawa,
                style: GoogleFonts.notoSerifSinhala(fontSize: 14),
              ),
              // tileColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(8.0),
              // ),
              // onTap: () {
              //   // Define an action when the card is tapped, if necessary
              // },
            ),
          ),
        );
      },
    );
  }
}
