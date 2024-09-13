import 'dart:ui';

import 'package:aurudu_nakath/features/ui/litha/presentation/pages/widget/calendar_widget.dart';
import 'package:flutter/material.dart';



final Map<DateTime, List<Event>> sampleEvents = {
  DateTime.utc(2024, 1, 1): [
    Event('නවසැම අවුරුදු උත්සවය', Colors.blue),
  ],
  DateTime.utc(2024, 2, 14): [
    Event('ආදරවන්තයින්ගේ දිනය', Colors.red),
  ],
  DateTime.utc(2024, 3, 21): [
    Event('බසන්ත වර්ෂානුස්ථාව', Colors.green),
    Event('අන්‍යජාතික ගැටුම් අහරනය දිනය', Colors.purple),
  ],
  DateTime.utc(2024, 4, 7): [
    Event('විශ්ව සෞඛ්‍ය දිනය', Colors.teal),
  ],
  DateTime.utc(2024, 5, 1): [
    Event('අන්තර්ජාතික කම්කරුවන්ගේ දිනය', Colors.orange),
  ],
  DateTime.utc(2024, 12, 25): [
    Event('නත්තල්', Colors.green),
    Event('බොක්සිං දිනය', Colors.red),
  ],
  DateTime.utc(2024, 1, 25): [
    Event('දුරුතු පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 2, 4): [
    Event('නිදහස් දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 2, 23): [
    Event('නවම් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 3, 8): [
    Event('මහා ශිවරාත්‍රී දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 3, 11): [
    Event('රාමසාන් ආරම්භය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 3, 24): [
    Event('මැදින් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 3, 29): [
    Event('මහ සිකුරාදා', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 3, 31): [
    Event('පාස්කු ඉරිදා', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 4, 11): [
    Event('රාමසාන් දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 4, 12): [
    Event('සිංහල දෙමළ පරණ අවුරුදු දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 4, 13): [
    Event('සිංහල දෙමළ අලුත් අවුරුදු දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 4, 23): [
    Event('බක් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 5, 12): [
    Event('අම්මාවරුන්ගේ දිනය', Color.fromARGB(255, 255, 145, 0)),
  ],
  DateTime.utc(2024, 5, 23): [
    Event('වෙසක් පුර පසලොස්වක පොහෝ දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 5, 24): [
    Event('වෙසල් දිනට පසු දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 6, 16): [
    Event('පිය වරුන්ගේ දිනය', Color.fromARGB(255, 255, 145, 0)),
  ],
  DateTime.utc(2024, 6, 17): [
    Event('හජ්ජි උත්සව දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 6, 21): [
    Event('පොසොන් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 7, 20): [
    Event('ඇසළ පුර පසලොස්වක පොහෝ දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 8, 19): [
    Event('නිකිනි පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 9, 16): [
    Event('නබි නායකතුමාගේ උපන් දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 9, 17): [
    Event('බිනර පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 10, 17): [
    Event('වප් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 10, 31): [
    Event('දීපවාලී උත්සව දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 11, 15): [
    Event('ඉල් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
  DateTime.utc(2024, 12, 14): [
    Event('උදුවප් පුර පසලොස්වක පෝය දිනය', Color.fromARGB(255, 255, 238, 0)),
  ],
};
