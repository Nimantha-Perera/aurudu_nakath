

import 'package:aurudu_nakath/features/ui/litha/domain/entities/event.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/maru_sitina_disawa.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/rashi_aya_waya.dart';
import 'package:aurudu_nakath/features/ui/litha/domain/entities/sunan_agawatima.dart';

class AuruduNakathData {
  // final Map<DateTime, List<Event>> events;
  final List<MaruSitinaDisawa> maruSitinaDisawa;
  final List<String> konaMasa;
  final List<SunanAgawatima> sunanAgawatima;
  final List<RashiAyawaya> rashi_aya_waya;

  AuruduNakathData({
    // required this.events,
    required this.maruSitinaDisawa,
    required this.konaMasa,
    required this.sunanAgawatima,
    required this.rashi_aya_waya,
  });
}
