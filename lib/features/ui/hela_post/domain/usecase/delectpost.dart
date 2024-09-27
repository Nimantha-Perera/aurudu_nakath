import 'package:cloud_firestore/cloud_firestore.dart';

class DeletePostUseCase {
  final FirebaseFirestore firestore;

  DeletePostUseCase({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> deletePost(String postId) async {
    try {
      // Assuming you have a collection named 'posts'
      await firestore.collection('posts').doc(postId).delete();
      print('Post deleted successfully.');
    } catch (e) {
      print('Error deleting post: $e');
      throw Exception('Failed to delete post: $e');
    }
  }
}
