import 'package:aurudu_nakath/features/ui/hela_post/data/repo/post_repository_impl.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/prvider/post_provider.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/datasource.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/getallpost.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/post_widget.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllPostsScreen extends StatelessWidget {
  const AllPostsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider(
        GetAllPosts(PostRepositoryImpl(FirebasePostDataSource(FirebaseFirestore.instance))))
          ..fetchAllPosts(),
      
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Posts'),
        ),
        body: Consumer<PostProvider>(
          builder: (context, postProvider, _) {
            if (postProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (postProvider.hasError) {
              return const Center(child: Text('Error loading posts'));
            }

            // Check if posts are empty and display a message accordingly
            if (postProvider.posts.isEmpty) {
              return const Center(child: Text('No posts available'));
            }

            return ListView.builder(
              itemCount: postProvider.posts.length,
              itemBuilder: (context, index) {
                final post = postProvider.posts[index];
                return PostWidget(post: post); // Pass the entire post object
              },
            );
          },
        ),
      ),
    );
  }
}
