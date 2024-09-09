import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final bool isTimeCount;
  final Timestamp timestamp;

  Notice({
    required this.isTimeCount,
    required this.timestamp,
  });
}
