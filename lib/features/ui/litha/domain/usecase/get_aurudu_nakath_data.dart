
import 'package:aurudu_nakath/features/ui/litha/data/repo/aurudu_nakath_repository.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/aurudu_nakath_data.dart';

class GetAuruduNakathData {
  final AuruduNakathRepository repository;

  GetAuruduNakathData({required this.repository});

  Future<AuruduNakathData> call() async {
    return await repository.getAuruduNakathData();
  }
}