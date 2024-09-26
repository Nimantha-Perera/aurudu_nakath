

import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository.dart';

class GetAllPosts {
  final PostRepository repository;

  GetAllPosts(this.repository);

  Future<List<Post>> call() async {
    return await repository.getAllPosts();
  }
}
