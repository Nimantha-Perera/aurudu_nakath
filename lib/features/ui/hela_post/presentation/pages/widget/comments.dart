import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago; // Importing the package

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  List<Map<String, dynamic>> comments = [];
  final TextEditingController commentController = TextEditingController();
  String? editingCommentId;
  bool isLoading = false;
  String? currentUserId;
  String? currentUserName;
  String? currentPhotoUrl;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
    _fetchComments();
  }

  Future<void> _fetchCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
      currentUserName = prefs.getString('displayName');
      currentPhotoUrl = prefs.getString('photoURL');
    });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('අදහස්', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : comments.isEmpty
                  ? _buildEmptyState(isDarkMode)
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return _buildCommentItem(comments[index], isDarkMode);
                      },
                    ),
          const SizedBox(height: 8),
          _buildCommentInput(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment_outlined,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              size: 50),
          const SizedBox(height: 8),
          Text('අදහස් නොමැත',
              style: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> commentData, bool isDarkMode) {
    bool isAuthor = commentData['authorId'] == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onLongPress: isAuthor ? () => _showCommentOptions(commentData['id'], commentData['text']) : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              backgroundImage: NetworkImage(commentData['userPhotoUrl'] ?? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
              child: commentData['userPhotoUrl'] == null
                  ? Icon(Icons.person, color: isDarkMode ? Colors.grey[300] : Colors.grey[600])
                  : null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentData['userName'] ?? 'Unknown User',
                    style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                  ),
                  Text(
                    commentData['text'],
                    style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                  ),
                  // Format timestamp using timeago
                  Text(
                    _formatTimestamp(commentData['timestamp']),
                    style: GoogleFonts.roboto(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput(bool isDarkMode) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: editingCommentId == null ? 'අදහස් පලකරන්න...' : 'ඔබේ අදහස සංස්කරණය කරන්න...',
              filled: true,
              fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: editingCommentId == null ? _addComment : _updateComment,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.send,
                color: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : const Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchComments() async {
    setState(() {
      isLoading = true;
    });
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      if (mounted) {
        setState(() {
          comments = snapshot.docs.map((doc) => {
                'id': doc.id,
                'text': doc['text'],
                'timestamp': doc['timestamp'],
                'authorId': doc['authorId'],
                'userName': doc['userName'],
                'userPhotoUrl': doc['userPhotoUrl'],
              }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching comments: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addComment() async {
    if (currentUserId == null || currentUserId!.isEmpty || currentUserName == null || currentUserName!.isEmpty) {
      Navigator.pushNamed(context, AppRoutes.login);
      return;
    }

    if (commentController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .add({
          'text': commentController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'authorId': currentUserId,
          'userName': currentUserName,
          'userPhotoUrl': currentPhotoUrl,
        });

        commentController.clear();
        _fetchComments();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස ඇතුළත් කළා')));
      } catch (e) {
        print('Error adding comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස ඇතුළත් කිරීමේදී දෝෂයක් ඇතිවිය')));
      }
    }
  }

  Future<void> _updateComment() async {
    if (editingCommentId == null || commentController.text.isEmpty) return;

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(editingCommentId)
          .update({'text': commentController.text});
      commentController.clear();
      editingCommentId = null;
      _fetchComments();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස යාවත්කාලීන කරන ලදි')));
    } catch (e) {
      print('Error updating comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස යාවත්කාලීන කිරීමේදී දෝෂයක් ඇතිවිය')));
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    if (timestamp == null) return ''; // Ensure timestamp is valid
    DateTime dateTime = timestamp.toDate();
    return timeago.format(dateTime, locale: 'si'); // 'si' for Sinhala language
  }

  void _showCommentOptions(String commentId, String commentText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comment Options'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  editingCommentId = commentId;
                  commentController.text = commentText;
                });
                Navigator.pop(context);
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                _deleteComment(commentId);
                Navigator.pop(context);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(commentId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස මකන ලදි')));
      _fetchComments();
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස මකන ආකාරය පිළිබඳ දෝෂයක් ඇතිවිය')));
    }
  }
}
