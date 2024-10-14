import 'package:aurudu_nakath/features/ui/home/data/modals/modal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class NoticeRepository {
  Stream<List<Notice>> getNotices();
}

class NoticeRepositoryImpl implements NoticeRepository {
  final FirebaseFirestore firestore;

  NoticeRepositoryImpl({required this.firestore});

  @override
  Stream<List<Notice>> getNotices() {
    return firestore.collection('notices').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final String? title = doc.data().containsKey('title')
            ? doc['title'] as String?
            : null;

        final String? subtitle = doc.data().containsKey('subtitle')
            ? doc['subtitle'] as String?
            : null;

        final Timestamp? noticeTimestamp = doc.data().containsKey('noticeTime')
            ? doc['noticeTime'] as Timestamp?
            : null;

        final DateTime? noticeTime = noticeTimestamp?.toDate(); // Removed '?? null'

        return Notice(
          title: title,
          subtitle: subtitle,
          noticeTime: noticeTime,
        );
      }).toList();
    });
  }
}
