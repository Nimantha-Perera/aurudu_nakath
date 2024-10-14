import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FetchCommentCountUseCase {


  // Constructor to accept postId
  FetchCommentCountUseCase();

  // Fetch comment count for a specific post
  Future<int> fetchCommentCount(String postId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .get();

      return snapshot.docs.length; // Return comment count
    } catch (e) {
      print('Error fetching comments count: $e');
      return 0; // Return 0 in case of error
    }
  }
}
