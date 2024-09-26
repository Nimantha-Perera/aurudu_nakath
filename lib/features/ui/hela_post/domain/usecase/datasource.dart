import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class PostDataSource {
  Future<List<Post>> getAllPosts();
  Future<Post?> getPostById(String id);
}

class FirebasePostDataSource implements PostDataSource {
  final FirebaseFirestore firestore;

  FirebasePostDataSource(this.firestore);

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      final QuerySnapshot snapshot = await firestore.collection('posts').get();
      return snapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          title: doc['title'] ?? '',
          description: doc['description'] ?? '',
          imageUrl: doc['imageUrl'] ?? '',
          auther_aveter: doc['auther_aveter'] ?? '',
          author: doc['auther'] ?? '',
          // Convert Timestamp to DateTime
          createdTime: (doc['created_date'] as Timestamp?)?.toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }

  @override
  Future<Post?> getPostById(String id) async {
    try {
      final DocumentSnapshot doc = await firestore.collection('posts').doc(id).get();
      if (doc.exists) {
        return Post(
          id: doc.id,
          title: doc['title'] ?? '',
          author: doc['auther'] ?? '',
          // Convert Timestamp to DateTime
          createdTime: (doc['created_date'] as Timestamp?)?.toDate(),
          description: doc['description'] ?? '',
          auther_aveter: doc['auther_aveter'] ?? '',
          imageUrl: doc['imageUrl'] ?? '',
        );
      } else {
        return null; // Post not found
      }
    } catch (e) {
      throw Exception('Failed to fetch post by ID: $e');
    }
  }
}
