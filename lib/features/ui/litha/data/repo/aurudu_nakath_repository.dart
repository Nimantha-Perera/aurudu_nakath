
import 'package:aurudu_nakath/features/ui/litha/domain/entities/aurudu_nakath_data.dart';

abstract class AuruduNakathRepository {
  Future<AuruduNakathData> getAuruduNakathData();
}