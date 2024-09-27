import 'package:cloud_firestore/cloud_firestore.dart';

class LikeCountUseCase {

  Future<void> incrementLikeCount(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'likeCount': FieldValue.increment(1),
    });
  }

  Future<void> decrementLikeCount(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).update({
      'likeCount': FieldValue.increment(-1),
    });
  }
}