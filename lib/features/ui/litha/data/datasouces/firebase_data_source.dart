import 'package:aurudu_nakath/features/ui/litha/domain/entities/event.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/maru_sitina_disawa.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/sunan_agawatima.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FirebaseDataSource {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

//   Future<Map<DateTime, List<Event>>> getEvents() async {
//   // Hardcoded events
//   final Map<DateTime, List<Event>> hardcodedEvents = {
//     DateTime(2024, 1, 25): [
//       Event(
//           title: 'දුරුතු පුර පසලොස්වක පෝය දිනය',
//           color: Color.fromARGB(255, 255, 238, 0)),
//     ],
//     DateTime(2024, 2, 4): [
//       Event(title: 'නිදහස් දිනය', color: Color.fromARGB(255, 255, 238, 0)),
//     ],
//     // Add more hardcoded events here...
//   };

//   try {
//     DataSnapshot snapshot = await _database.child('events').get();
//     if (snapshot.value != null) {
//       Map<DateTime, List<Event>> events = {};
//       Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
//       values.forEach((key, value) {
//         DateTime date = DateTime.parse(key);
//         List<Event> eventList = [];
        
//         if (value is List) {
//           for (var item in value) {
//             String colorString = item['color'].toString().replaceFirst('#', '');
//             Color color = Color(int.parse(colorString, radix: 16) | 0xFF000000); // Add alpha value
//             eventList.add(Event(
//               title: item['title'],
//               color: color,
//             ));
//           }
//         } else if (value is Map) {
//           value.forEach((eventKey, eventValue) {
//             String colorString = eventValue['color'].toString().replaceFirst('#', '');
//             Color color = Color(int.parse(colorString, radix: 16) | 0xFF000000); // Add alpha value
//             eventList.add(Event(
//               title: eventValue['title'],
//               color: color,
//             ));
//           });
//         }
//         events[date] = eventList;
//       });
//       return events;
//     } else {
//       return hardcodedEvents; // Return hardcoded events if no data from Firebase
//     }
//   } catch (e) {
//     print('Error fetching events: $e');
//     return hardcodedEvents; // Return hardcoded events if error occurs
//   }
// }


  Future<List<MaruSitinaDisawa>> getMaruSitinaDisawa() async {
    try {
      DataSnapshot snapshot = await _database.child('aurudu_nakath/maru_sitina_disawa').get();
      List<MaruSitinaDisawa> maruSitinaDisawaList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          maruSitinaDisawaList.add(MaruSitinaDisawa(
            dawasa: value['dawasa'],
            disawa: value['disawa'],
          ));
        });
      }

      return maruSitinaDisawaList;
    } catch (e) {
      print('Error fetching maru sitina disawa data: $e');
      return [];
    }
  }

  Future<List<String>> getKonaMasa() async {
    try {
      DataSnapshot snapshot = await _database.child('aurudu_nakath/kona_masa').get();
      List<String> konaMasaList = [];

      if (snapshot.value != null) {
        if (snapshot.value is List) {
          konaMasaList = List<String>.from(snapshot.value as List);
        } else if (snapshot.value is Map) {
          Map<dynamic, dynamic> values =
              snapshot.value as Map<dynamic, dynamic>;
          values.forEach((key, value) {
            konaMasaList.add(value.toString());
          });
        }
      }

      return konaMasaList;
    } catch (e) {
      print('Error fetching kona masa data: $e');
      return [];
    }
  }

  Future<List<SunanAgawatima>> getSunanAgawatima() async {
    try {
      DataSnapshot snapshot = await _database.child('sunan_agawatima').get();
      List<SunanAgawatima> sunanAgawatimaList = [];

      if (snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        values.forEach((key, value) {
          sunanAgawatimaList.add(SunanAgawatima(
            thana: value['thana'],
            palapala: value['palapala'],
          ));
        });
      }

      return sunanAgawatimaList;
    } catch (e) {
      print('Error fetching sunan agawatima data: $e');
      return [];
    }
  }
}
