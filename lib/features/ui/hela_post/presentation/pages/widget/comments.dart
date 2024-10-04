import 'package:aurudu_nakath/features/ui/routes/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController commentController = TextEditingController();
  String? editingCommentId;
  String? currentUserId;
  String? currentUserName;
  String? currentPhotoUrl;
  int commentsToShow = 3; // Start with showing 3 comments initially

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId();
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
          Text(
            'අදහස්',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('comments')
                .orderBy('timestamp', descending: true)
                .snapshots(),  // Listening to real-time changes
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final comments = snapshot.data!.docs;

              if (comments.isEmpty) {
                return _buildEmptyState(isDarkMode);
              }

              // Display only `commentsToShow` comments, and allow showing more
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length < commentsToShow
                        ? comments.length
                        : commentsToShow, // Show only up to the current limit
                    itemBuilder: (context, index) {
                      final commentData = comments[index].data() as Map<String, dynamic>;
                      return _buildCommentItem(commentData, comments[index].id, isDarkMode);
                    },
                  ),
                  if (comments.length > commentsToShow)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          commentsToShow += 3; // Increase commentsToShow by 3
                        });
                      },
                      child: Text(
                        'වැඩි අදහස් පෙන්වන්න',
                        style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.blue[300] : Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
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
          Icon(Icons.chat_bubble_outline,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              size: 60),
          const SizedBox(height: 16),
          Text(
            'අදහස් නොමැත',
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> commentData, String commentId, bool isDarkMode) {
    bool isAuthor = commentData['authorId'] == currentUserId;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onLongPress: isAuthor
            ? () => _showCommentOptions(commentId, commentData['text'])
            : null,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              backgroundImage: NetworkImage(commentData['userPhotoUrl'] ?? 
                  'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
              child: commentData['userPhotoUrl'] == null
                  ? Icon(Icons.person, color: isDarkMode ? Colors.grey[300] : Colors.grey[600])
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      commentData['userName'] ?? 'Unknown User',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      commentData['text'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimestamp(commentData['timestamp']),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isDarkMode ? Colors.grey[500] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: editingCommentId == null
                    ? 'අදහස් පලකරන්න...'
                    : 'ඔබේ අදහස සංස්කරණය කරන්න...',
                border: InputBorder.none,
                hintStyle: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              style: GoogleFonts.poppins(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: editingCommentId == null ? _addComment : _updateComment,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: isDarkMode ? Colors.black : Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    return timeago.format(timestamp.toDate(), locale: 'si');
  }

  Future<void> _addComment() async {
    if (commentController.text.trim().isEmpty) return;

    final newComment = {
      'text': commentController.text,
      'authorId': currentUserId,
      'userName': currentUserName,
      'userPhotoUrl': currentPhotoUrl,
      'timestamp': Timestamp.now(),
    };

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .add(newComment);

    commentController.clear();
  }

  Future<void> _updateComment() async {
    if (editingCommentId == null || commentController.text.trim().isEmpty) return;

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('comments')
        .doc(editingCommentId)
        .update({
      'text': commentController.text,
    });

    setState(() {
      editingCommentId = null;
    });

    commentController.clear();
  }

  void _showCommentOptions(String commentId, String currentText) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('සංස්කරණය කරන්න'),
              onTap: () {
                setState(() {
                  editingCommentId = commentId;
                  commentController.text = currentText;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('මකන්න'),
              onTap: () {
                FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('comments')
                    .doc(commentId)
                    .delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
