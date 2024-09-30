import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/delectpost.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/fetch_comment_count.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/like.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/widget/comments.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostWidget extends StatefulWidget {
  final Post post;
final VoidCallback refreshCallback;
  const PostWidget({Key? key, required this.post, required this.refreshCallback}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget>
    with SingleTickerProviderStateMixin {
  final FetchCommentCountUseCase _fetchCommentCountUseCase =
      FetchCommentCountUseCase();
  final LikeCountUseCase _likeCountUseCase = LikeCountUseCase();

  bool isLiked = false;
  late int likeCount;
  int commentCount = 0;
  bool showComments = false;
  bool isDescriptionExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  String? currentUserId;
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    _fetchCommentCount();
    likeCount = widget.post.likeCount;
    _getCurrentUserId();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUserId = prefs.getString('userId');
    });
  }

  Future<void> _checkSubscribed() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSubscribed = prefs.getBool('isSubscribed') ?? false;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final subtleColor = isDarkMode ? Colors.grey[700] : Colors.grey[300];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      elevation: 4,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDarkMode, textColor),
          _buildImage(),
          _buildContent(isDarkMode, textColor),
          _buildFooter(isDarkMode, subtleColor!),
          if (showComments) CommentSection(postId: widget.post.id),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDarkMode, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.post.auther_aveter),
            radius: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.author,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: textColor,
                  ),
                ),
                Text(
                  widget.post.createdTime != null
                      ? DateFormat('MMM d, yyyy • HH:mm')
                          .format(widget.post.createdTime!)
                      : 'Date not available',
                  style: GoogleFonts.roboto(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          if (currentUserId == widget.post.userId)
            _buildDeleteButton(isDarkMode),
          _buildReportButton(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDeleteButton(bool isDarkMode) {
    return IconButton(
      icon: Icon(Icons.delete, color: isDarkMode ? Colors.red[300] : Colors.red),
      onPressed: _handleDelete,
    );
  }

 Widget _buildReportButton(bool isDarkMode) {
    return PopupMenuButton<String>(
      icon: Icon(Icons.flag_outlined,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
      onSelected: (String result) async {
        if (result == 'report') {
          // Call the function to report the post
          await _reportPost(widget.post.id);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post reported')),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Text('Report Post'),
        ),
      ],
    );
  }

  Future<void> _reportPost(String postId) async {
    try {
      // Assuming you have a Firestore collection named 'reported_posts'
      await FirebaseFirestore.instance.collection('reported_posts').add({
        'post_id': postId,
        'timestamp': FieldValue.serverTimestamp(), // Optionally add a timestamp
      });
    } catch (e) {
      // Handle any errors
      print('Error reporting post: $e');
    }
  }


  Widget _buildImage() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(post: widget.post),
          ),
        );
      },
      child: Hero(
        tag: 'postImage${widget.post.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: widget.post.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: widget.post.imageUrl,
                  fit: BoxFit.cover,
                  height: 250,
                  width: double.infinity,
                  placeholder: (context, url) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Container(),
        ),
      ),
    );
  }

  Widget _buildContent(bool isDarkMode, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: isDescriptionExpanded
                ? widget.post.description
                : _getTruncatedDescription(),
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(
                color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isDescriptionExpanded = !isDescriptionExpanded;
                isDescriptionExpanded
                    ? _animationController.forward()
                    : _animationController.reverse();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDescriptionExpanded ? 'Show Less' : 'Show More',
                  style: GoogleFonts.roboto(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.keyboard_arrow_down,
                      color: Theme.of(context).primaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(bool isDarkMode, Color subtleColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: subtleColor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInteractionButton(
            icon: isLiked ? Icons.favorite : Icons.favorite_border,
            label: _formatCount(likeCount),
            onPressed: _handleLike,
            color: isLiked
                ? (isDarkMode ? Colors.red[300] : Colors.red)
                : (isDarkMode ? Colors.white : Colors.black),
          ),
          _buildInteractionButton(
            icon: Icons.comment_outlined,
            label: '$commentCount',
            onPressed: _handleComment,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  void _handleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
      if (isLiked) {
        _likeCountUseCase.incrementLikeCount(widget.post.id);
      } else {
        _likeCountUseCase.decrementLikeCount(widget.post.id);
      }
    });
  }

  void _handleComment() {
    setState(() {
      showComments = !showComments;
    });
  }

  String _getTruncatedDescription() {
    const int maxLength = 100;
    if (widget.post.description.length <= maxLength) {
      return widget.post.description;
    }
    return widget.post.description.substring(0, maxLength) + '...';
  }

  Future<void> _fetchCommentCount() async {
    commentCount =
        await _fetchCommentCountUseCase.fetchCommentCount(widget.post.id);
    setState(() {});
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  Future<void> _handleDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final deletePostUseCase = DeletePostUseCase();
                try {
                  await deletePostUseCase.deletePost(widget.post.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post deleted successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting post: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              child: const Text('Delete'),
            )
          ],
        );
      },
    );
  }
}