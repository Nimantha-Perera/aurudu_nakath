import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/getallpost.dart';
import 'package:flutter/foundation.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';


class PostProvider with ChangeNotifier {
  final GetAllPosts _getAllPosts;
  List<Post> _posts = [];
  bool _isLoading = false;
  bool _hasError = false;

  PostProvider(this._getAllPosts);

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  Future<void> fetchAllPosts() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    
    try {
      _posts = await _getAllPosts.call();
    } catch (e) {
      _hasError = true;
      _posts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
