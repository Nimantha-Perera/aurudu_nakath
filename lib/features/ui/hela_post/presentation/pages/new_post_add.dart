import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:google_fonts/google_fonts.dart';
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

  File? _imageFile;
  String? _uploadedImageUrl;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;

  bool _isLoading = false;

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
      author = prefs.getString('displayName') ?? 'නිර්නාමික';
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
      setState(() => _isLoading = true);
      try {
        String postId = _generatePostId();
        Reference storageRef = storage.ref().child('post_images/$postId.jpg');
        UploadTask uploadTask = storageRef.putFile(_imageFile!);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          _uploadedImageUrl = downloadUrl;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar('පින්තූරය උඩුගත කිරීම අසාර්ථක විය: $e', isError: true);
      }
    }
  }

  Future<void> _deleteImageFromFirebase() async {
    if (_uploadedImageUrl != null) {
      setState(() => _isLoading = true);
      try {
        Reference storageRef = storage.refFromURL(_uploadedImageUrl!);
        await storageRef.delete();
        setState(() {
          _uploadedImageUrl = null;
          _imageFile = null;
          _isLoading = false;
        });
        _showSnackBar('පින්තූරය සාර්ථකව මකා දමන ලදී!');
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar('පින්තූරය මකා දැමීම අසාර්ථක විය: $e', isError: true);
      }
    }
  }

  Future<void> _createPost() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      Post newPost = Post(
        id: _generatePostId(),
        title: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _uploadedImageUrl ?? '',
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
        _showSnackBar('පළ කිරීම සාර්ථකව නිර්මාණය කරන ලදී!');
      } catch (e) {
        setState(() => _isLoading = false);
        _showSnackBar('පළ කිරීම නිර්මාණය කිරීම අසාර්ථක විය: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ලියන්න අපිට', style: GoogleFonts.notoSerifSinhala(fontSize: 14.0, color: Colors.white)),
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTitleField(),
                SizedBox(height: 20),
                _buildDescriptionField(),
                SizedBox(height: 24),
                _buildImageSection(),
                SizedBox(height: 32),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        labelText: 'මාතෘකාව',
        hintText: 'ඔබේ පළ කිරීමේ මාතෘකාව ඇතුළත් කරන්න',
        prefixIcon: Icon(Icons.title),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
      validator: (value) => value!.isEmpty ? 'මාතෘකාව අවශ්‍ය වේ' : null,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: InputDecoration(
        labelText: 'විස්තරය',
        hintText: 'ඔබේ පළ කිරීමේ අන්තර්ගතය මෙහි ලියන්න',
        prefixIcon: Icon(Icons.description),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
      ),
      maxLines: 5,
      validator: (value) => value!.isEmpty ? 'විස්තරය අවශ්‍ය වේ' : null,
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'පින්තූරයක් එකතු කරන්න',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        if (_uploadedImageUrl != null)
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  _uploadedImageUrl!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: _deleteImageFromFirebase,
                  ),
                ),
              ),
            ],
          )
        else
          InkWell(
            onTap: _pickImage,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).colorScheme.primary),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 48, color: Theme.of(context).colorScheme.primary),
                  SizedBox(height: 8),
                  Text('පින්තූරයක් එකතු කිරීමට තට්ටු කරන්න', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _createPost,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: _isLoading
          ? CircularProgressIndicator(color: Theme.of(context).colorScheme.onPrimary)
          : Text(
              'පළ කිරීම සාදන්න',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
    );
  }
}