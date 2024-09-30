import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class DeletePostUseCase {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  DeletePostUseCase({FirebaseFirestore? firestore, FirebaseStorage? storage})
      : firestore = firestore ?? FirebaseFirestore.instance,
        storage = storage ?? FirebaseStorage.instance;

  Future<void> deletePost(String postId) async {
    try {
      // Retrieve the post document
      DocumentSnapshot postSnapshot = await firestore.collection('posts').doc(postId).get();

      if (!postSnapshot.exists) {
        throw Exception('Post not found.');
      }

      // Extract the image URL (if available)
      String? imageUrl = postSnapshot['imageUrl'];

      // Delete the image from Firebase Storage if the imageUrl exists
      if (imageUrl != null && imageUrl.isNotEmpty) {
        Reference imageRef = storage.refFromURL(imageUrl);
        await imageRef.delete();
        print('Image deleted successfully.');
      }

      // Delete the post from Firestore
      await firestore.collection('posts').doc(postId).delete();
      print('Post deleted successfully.');

    } catch (e) {
      print('Error deleting post or image: $e');
      throw Exception('Failed to delete post or image: $e');
    }
  }
}
