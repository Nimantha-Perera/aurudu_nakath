import 'package:aurudu_nakath/features/ui/lagna_palapala/data/repositories/lagna_palapala_repository.dart';
import 'package:aurudu_nakath/features/ui/lagna_palapala/domain/lagna_palapala_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LagnaPalapalaCubit extends Cubit<List<LagnaPalapalaModel>> {
  final LagnaPalapalaRepository _repository;

  LagnaPalapalaCubit(this._repository) : super([]);

  void fetchLagnaPalapala() {
    _repository.getLagnaPalapalaStream().listen((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map<dynamic, dynamic>;
        final sortedList = data.entries.toList()
          ..sort((a, b) => b.value['index_no'].compareTo(a.value['index_no']));
        final filteredList = sortedList.where((entry) {
          int index = entry.value['index_no'];
          return index >= 1 && index <= 12;
        }).map((entry) => LagnaPalapalaModel.fromMap(entry.value)).toList();
        emit(filteredList);
      }
    });
  }
}
