import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';

abstract class PostRepository {
  Future<Post?> getPostById(String postId);
  Future<List<Post>> getAllPosts();  // New method to fetch all posts
}
