import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository.dart';

import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostDataSource dataSource;

  PostRepositoryImpl(this.dataSource);

  @override
  Future<List<Post>> getAllPosts() async {
    try {
      return await dataSource.getAllPosts();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  @override
  Future<Post?> getPostById(String id) async {
    try {
      // Assuming your data source has a method to fetch a single post by ID
      return await dataSource.getPostById(id);
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }
}
