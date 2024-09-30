import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String author = '';
  String authorAvatar = '';
  DateTime createdTime = DateTime.now();
  int likeCount = 0;
  String userid = '';

  File? _imageFile; // To store the selected image file
  String? _uploadedImageUrl; // To store the uploaded image URL

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
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

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      await _uploadImageToFirebase();
    }
  }

  Future<void> _uploadImageToFirebase() async {
    if (_imageFile != null) {
      try {
        String postId = _generatePostId();
        Reference storageRef = storage.ref().child('post_images/$postId.jpg');
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _uploadedImageUrl = downloadUrl;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image upload failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteImageFromFirebase() async {
    if (_uploadedImageUrl != null) {
      try {
        Reference storageRef = storage.refFromURL(_uploadedImageUrl!);
        await storageRef.delete();
        setState(() {
          _uploadedImageUrl = null;
          _imageFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image deleted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image deletion failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      Post newPost = Post(
        id: _generatePostId(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _uploadedImageUrl ?? '', // Set the uploaded image URL
        author: author,
        auther_aveter: authorAvatar,
        createdTime: createdTime,
        likeCount: likeCount,
        userId: userid,
      );

      try {
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final cardColor = isDarkMode ? Colors.grey[800] : Colors.white;
    final inputFillColor = isDarkMode ? Colors.grey[700] : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Container(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title Input
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Title is required' : null,
              ),
              SizedBox(height: 16),
              
              // Description Input
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 5,
                validator: (value) =>
                    value!.isEmpty ? 'Description is required' : null,
              ),
              SizedBox(height: 16),
              
              // Image upload section
              if (_uploadedImageUrl != null)
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.network(
                      _uploadedImageUrl!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: _deleteImageFromFirebase,
                    ),
                  ],
                )
              else
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image),
                  label: Text('Upload Image'),
                ),
              
              SizedBox(height: 24),
              
              // Submit button
              ElevatedButton(
                onPressed: _createPost,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Create Post',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
