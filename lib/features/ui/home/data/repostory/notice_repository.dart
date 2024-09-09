import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NoticeRepository {
  Stream<List<String>> getNotices();
}

class NoticeRepositoryImpl implements NoticeRepository {
  final FirebaseFirestore firestore;

  NoticeRepositoryImpl({required this.firestore});

  @override
  Stream<List<String>> getNotices() {
    return firestore.collection('notices').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc['text'] as String).toList();
    });
  }
}
