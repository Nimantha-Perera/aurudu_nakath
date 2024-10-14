import 'package:firebase_database/firebase_database.dart';

class RaahuKaalayaRepository {
  final DatabaseReference _reference = FirebaseDatabase.instance.ref().child('raahu_kalaya');

  Future<DatabaseEvent> getRaahuKaalayaData() async {
    final snapshot = await _reference.once();
    return snapshot;
  }
}
