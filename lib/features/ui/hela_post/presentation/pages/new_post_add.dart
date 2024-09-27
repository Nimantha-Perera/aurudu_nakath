import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String author = '';
  String authorAvatar = '';
  DateTime createdTime = DateTime.now();
  int likeCount = 0;
  String userid = '';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      authorAvatar = prefs.getString('photoURL') ?? '';
      author = prefs.getString('displayName') ?? 'Anonymous';
      userid = prefs.getString('userId') ?? '';

    });
  }

  String _generatePostId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${author.replaceAll(' ', '_')}_${timestamp}_${random.nextInt(1000)}';
  }

  Future<void> _createPost() async {
  if (_formKey.currentState!.validate()) {
    Post newPost = Post(
      id: _generatePostId(),
      title: _titleController.text,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
      author: author,
      auther_aveter: authorAvatar,
      createdTime: createdTime,
      likeCount: likeCount,
      userId: userid,
    );

    try {
      // Use the post ID as the document ID
      await firestore.collection('posts').doc(newPost.id).set({
        'id': newPost.id,
        'title': newPost.title,
        'description': newPost.description,
        'imageUrl': newPost.imageUrl,
        'auther': newPost.author,
        'auther_aveter': newPost.auther_aveter,
        'created_date': newPost.createdTime,
        'likeCount': newPost.likeCount,
        'userId': newPost.userId,
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create post: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'ලියන්න අපට',
          style: TextStyle(
            fontSize: 15,

            color: Colors.white, // Set the title color to white for contrast
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
          ),
        ),
        child: SafeArea(
          child: Center(
            // Center the contents
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'මාතෘකාව',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.title,
                                      color: Theme.of(context).primaryColor),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                validator: (value) =>
                                    value!.isEmpty ? 'මාතෘකාව අවශ්‍යයි' : null,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'අන්තර්ගතය',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.description,
                                      color: Theme.of(context).primaryColor),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                maxLines: 5,
                                validator: (value) => value!.isEmpty
                                    ? 'අන්තර්ගතය අවශ්‍යයි'
                                    : null,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _imageUrlController,
                                decoration: InputDecoration(
                                  labelText: 'ජායාරූප සබැදිය මෙතන අලවන්න',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.image,
                                      color: Theme.of(context).primaryColor),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                // Remove validation for the image URL
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _createPost,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'එක් කරන්න',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
