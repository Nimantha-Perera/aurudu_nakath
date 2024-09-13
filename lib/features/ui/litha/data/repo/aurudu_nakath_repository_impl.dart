

import 'package:aurudu_nakath/features/ui/litha/data/datasouces/firebase_data_source.dart';
import 'package:aurudu_nakath/features/ui/litha/data/repo/aurudu_nakath_repository.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/aurudu_nakath_data.dart';

class AuruduNakathRepositoryImpl implements AuruduNakathRepository {
  final FirebaseDataSource dataSource;

  AuruduNakathRepositoryImpl({required this.dataSource});

  @override
  Future<AuruduNakathData> getAuruduNakathData() async {
    // final events = await dataSource.getEvents();
    final maruSitinaDisawa = await dataSource.getMaruSitinaDisawa();
    final konaMasa = await dataSource.getKonaMasa();
    final sunanAgawatima = await dataSource.getSunanAgawatima();

    return AuruduNakathData(
      // events: events,
      maruSitinaDisawa: maruSitinaDisawa,
      konaMasa: konaMasa,
      sunanAgawatima: sunanAgawatima,
    );
  }
}
