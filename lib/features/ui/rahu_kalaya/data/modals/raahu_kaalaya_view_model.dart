import 'package:aurudu_nakath/features/ui/rahu_kalaya/data/repostories/raahu_kaalaya_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'raahu_kaalaya_model.dart';

class RaahuKaalayaViewModel {
  final RaahuKaalayaRepository _repository = RaahuKaalayaRepository();

  Future<List<RaahuKaalayaModel>> fetchRaahuKaalayaData() async {
    final dataSnapshot = await _repository.getRaahuKaalayaData();
    final data = dataSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (data == null) return [];

    return data.entries.map((entry) {
      return RaahuKaalayaModel.fromMap(entry.value as Map<dynamic, dynamic>);
    }).toList();
  }
}
