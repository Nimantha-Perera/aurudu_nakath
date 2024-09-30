import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchComments();
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
          Icon(Icons.comment_outlined, color: isDarkMode ? Colors.grey[400] : Colors.grey[600], size: 50),
          const SizedBox(height: 8),
          Text('අදහස් නොමැත', style: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> commentData, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onLongPress: () => _showCommentOptions(commentData['id'], commentData['text']),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
              child: Icon(Icons.person, color: isDarkMode ? Colors.grey[300] : Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentData['text'],
                    style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(commentData['timestamp']),
                    style: TextStyle(fontSize: 12, color: isDarkMode ? Colors.grey[500] : Colors.grey[600]),
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
            child: Icon(Icons.send, color: Colors.white),
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
    if (commentController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .add({
          'text': commentController.text,
          'timestamp': FieldValue.serverTimestamp(),
        });

        commentController.clear();
        _fetchComments(); // Refresh comments after adding
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස ඇතුළත් කළා')));
      } catch (e) {
        print('Error adding comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස ඇතුළත් කිරීමේදී දෝෂයක් ඇතිවිය')));
      }
    }
  }

  Future<void> _updateComment() async {
    if (editingCommentId != null && commentController.text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .doc(editingCommentId)
            .update({
          'text': commentController.text,
        });

        commentController.clear();
        setState(() {
          editingCommentId = null; // Reset editing state
        });
        _fetchComments(); // Refresh comments after updating
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස යාවත්කාලීන කළා')));
      } catch (e) {
        print('Error updating comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස යාවත්කාලීන කිරීමේදී දෝෂයක් ඇතිවිය')));
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('comments')
          .doc(commentId)
          .delete();

      _fetchComments(); // Refresh comments after deleting
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස මකා දමන ලදී')));
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('අදහස මකා දැමීමේදී දෝෂයක් ඇතිවිය')));
    }
  }

  void _showCommentOptions(String commentId, String commentText) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('අදහස් විකල්ප'),
          content: Text(commentText),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          titleTextStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
          contentTextStyle: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[800]),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  editingCommentId = commentId;
                  commentController.text = commentText;
                });
                Navigator.of(context).pop();
              },
              child: Text('සංස්කරණය කරන්න', style: TextStyle(color: Theme.of(context).primaryColor)),
            ),
            TextButton(
              onPressed: () {
                _deleteComment(commentId);
                Navigator.of(context).pop();
              },
              child: Text('මකන්න', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('අවලංගු කරන්න', style: TextStyle(color: isDarkMode ? Colors.grey[300] : Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Just now';
    final date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year}, ${date.hour}:${date.minute}';
  }
}