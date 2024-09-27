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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : comments.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        return _buildCommentItem(comments[index]);
                      },
                    ),
          const SizedBox(height: 8),
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.comment_outlined, color: Colors.grey, size: 50),
          const SizedBox(height: 8),
          Text('No comments yet', style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> commentData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onLongPress: () => _showCommentOptions(commentData['id'], commentData['text']),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    commentData['text'],
                    style: TextStyle(color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTimestamp(commentData['timestamp']),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: commentController,
            decoration: InputDecoration(
              hintText: editingCommentId == null ? 'Add a comment...' : 'Edit your comment...',
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide.none,
              ),
            ),
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
            'id': doc.id, // Include the document ID for editing/deleting
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment added')));
      } catch (e) {
        print('Error adding comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding comment')));
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment updated')));
      } catch (e) {
        print('Error updating comment: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating comment')));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Comment deleted')));
    } catch (e) {
      print('Error deleting comment: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting comment')));
    }
  }

  void _showCommentOptions(String commentId, String commentText) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Comment Options'),
          content: Text(commentText),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  editingCommentId = commentId; // Set the comment ID for editing
                  commentController.text = commentText; // Populate the text field with existing comment
                });
                Navigator.of(context).pop();
              },
              child: Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                _deleteComment(commentId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
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
