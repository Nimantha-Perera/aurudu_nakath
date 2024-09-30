import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/app_bar_img.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/prvider/post_provider.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/getallpost.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/datasource.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/new_post_add.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/post_widget.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({Key? key}) : super(key: key);

  @override
  _AllPostsScreenState createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  String authorAvatar = '';
  String author = 'Anonymous';
  String userid = '';
  String appBarImageUrl = '';
  final LoadAppBarImageUseCase _loadAppBarImageUseCase =
      LoadAppBarImageUseCase();

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _loadAppBarImage();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authorAvatar = prefs.getString('photoURL') ?? '';
      author = prefs.getString('displayName') ?? 'Anonymous';
      userid = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _refreshPosts() async {
    await Provider.of<PostProvider>(context, listen: false).fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {


    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return ChangeNotifierProvider(
      create: (context) => PostProvider(
        GetAllPosts(PostRepositoryImpl(
            FirebasePostDataSource(FirebaseFirestore.instance))),
      )..fetchAllPosts(),
      child: Scaffold(
        body: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/app_background/backimg.png',  // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            // Main Content (ScrollView with AppBar and Posts)
            RefreshIndicator(
              onRefresh: _refreshPosts,
              child: CustomScrollView(
                slivers: [
                  _buildAppBar(),
                  _buildPostsList(),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: _buildFloatingActionButton(isDarkMode),
      ),
    );
  }

  Future<void> _loadAppBarImage() async {
    String imageUrl = await _loadAppBarImageUseCase.loadAppBarImage();
    setState(() {
      appBarImageUrl = imageUrl;
    });
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: const Text(
          'හෙළ ලිපි',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black45,
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            appBarImageUrl.isNotEmpty
                ? Image.network(
                    appBarImageUrl,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    'assets/icons/appbar.jpg',
                    fit: BoxFit.cover,
                  ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            // Navigate to profile page
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: authorAvatar.isNotEmpty
                  ? NetworkImage(authorAvatar)
                  : const NetworkImage('https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildPostsList() {
    return Consumer<PostProvider>(
      builder: (context, postProvider, _) {
        if (postProvider.isLoading) {
          return const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (postProvider.hasError) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading posts',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _refreshPosts,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (postProvider.posts.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.notes_outlined,
                      size: 60, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No posts available',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Be the first to create a post!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final post = postProvider.posts[index];
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: PostWidget(post: post),
              );
            },
            childCount: postProvider.posts.length,
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
  return FloatingActionButton(
    shape: CircleBorder(),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CreatePostScreen()),
      );
    },
    child: Icon(
      Icons.edit,
      color: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
    ),
    backgroundColor: Theme.of(context).primaryColor,
    elevation: 4,
  );
}

}

