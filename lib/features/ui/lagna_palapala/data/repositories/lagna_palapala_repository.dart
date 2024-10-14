import 'package:firebase_database/firebase_database.dart';

class LagnaPalapalaRepository {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('lagna_palapala');

  Stream<DatabaseEvent> getLagnaPalapalaStream() {
    return _databaseRef.onValue;
  }
}
