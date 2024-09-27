import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/prvider/post_provider.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/datasource.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/getallpost.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/new_post_add.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/post_widget.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/widget/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllPostsScreen extends StatefulWidget {
  const AllPostsScreen({Key? key}) : super(key: key);

  @override
  _AllPostsScreenState createState() => _AllPostsScreenState();
}

class _AllPostsScreenState extends State<AllPostsScreen> {
  String authorAvatar = '';
  String author = 'Anonymous';
  String userid = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.fetchAllPosts(); // Refresh posts
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(
        GetAllPosts(PostRepositoryImpl(FirebasePostDataSource(FirebaseFirestore.instance))),
      )..fetchAllPosts(),
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshPosts, // Trigger refresh
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text(
                    'හෙළ ලිපි',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  background: Image.asset(
                    'assets/icons/appbar.jpg', // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
                actions: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundImage: authorAvatar.isNotEmpty
                          ? NetworkImage(authorAvatar) // Use the loaded profile image URL
                          : const NetworkImage('https://i.pravatar.cc/150?u=a042581f4e29026704d'), // Default image
                    ),
                    onPressed: () {
                      // Handle profile picture button tap
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => ProfilePage()), // Navigate to profile page
                      // );
                    },
                  ),
                  const SizedBox(width: 16), // Optional spacing
                ],
              ),
              Consumer<PostProvider>(
                builder: (context, postProvider, _) {
                  if (postProvider.isLoading) {
                    return const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (postProvider.hasError) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('Error loading posts')),
                    );
                  }

                  if (postProvider.posts.isEmpty) {
                    return const SliverFillRemaining(
                      child: Center(child: Text('No posts available')),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final post = postProvider.posts[index];
                        return PostWidget(post: post);
                      },
                      childCount: postProvider.posts.length,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreatePostScreen()),
            );
          },
          child: const Icon(Icons.edit, color: Colors.black),
          tooltip: 'Create Post',
        ),
      ),
    );
  }
}
