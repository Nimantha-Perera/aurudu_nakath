import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/getallpost.dart';
import 'package:flutter/material.dart';


class PostProvider extends ChangeNotifier {
  final GetAllPosts getAllPostsUseCase;

  List<Post> posts = [];
  bool isLoading = true;
  bool hasError = false;

  PostProvider(this.getAllPostsUseCase);

  Future<void> fetchAllPosts() async {
    try {
      isLoading = true;
      notifyListeners();

      posts = await getAllPostsUseCase.call();

      if (posts.isEmpty) {
        hasError = true;
      }
    } catch (e) {
      hasError = true;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
