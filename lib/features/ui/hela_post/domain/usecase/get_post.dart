import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository.dart';

class GetPost {
  final PostRepository repository;

  GetPost(this.repository);

  Future<Post?> call(String postId) async {
    return await repository.getPostById(postId);
  }
}
