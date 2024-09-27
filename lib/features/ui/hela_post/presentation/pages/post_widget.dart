import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/delectpost.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/fetch_comment_count.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/like.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/widget/comments.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'post_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _fetchCommentCount();
    likeCount = widget.post.likeCount;
    _getCurrentUserId(); // Get the current user ID from SharedPreferences

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
      currentUserId =
          prefs.getString('userId'); // Assuming 'userId' is the key used
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildImage(),
          _buildContent(),
          _buildFooter(),
          if (showComments) CommentSection(postId: widget.post.id),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(widget.post.auther_aveter),
            radius: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.author,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.post.createdTime != null
                      ? DateFormat('MMM d, yyyy • HH:mm')
                          .format(widget.post.createdTime!)
                      : 'Date not available',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          if (currentUserId == widget.post.userId)
            _buildDeleteButton(), // Show delete button if the user is the author
          _buildReportButton(),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return IconButton(
      icon: const Icon(Icons.delete, color: Colors.red),
      onPressed: _handleDelete,
    );
  }

  Future<void> _handleDelete() async {
    // Implement delete functionality here, such as showing a confirmation dialog
    // and deleting the post from Firestore
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Post'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final deletePostUseCase = DeletePostUseCase();

                try {
                  // Call the deletePost method first
                  await deletePostUseCase.deletePost(widget.post.id);

                  // Show a success message after the post is deleted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Post deleted successfully!'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );

                  // Close the dialog after the operation is complete
                  Navigator.of(context).pop();
                } catch (e) {
                  // Handle any errors
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

  Widget _buildReportButton() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.flag_outlined, color: Colors.grey[700]),
      onSelected: (String result) {
        // Handle report action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post reported')),
        );
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Text('Report Post'),
        ),
      ],
    );
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>PostDetailScreen(post: widget.post),
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

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
            data: isDescriptionExpanded
                ? widget.post.description
                : _getTruncatedDescription(),
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: Colors.grey[800], fontSize: 14),
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
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold),
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

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
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
            color: isLiked ? Colors.red : null,
          ),
          _buildInteractionButton(
            icon: Icons.comment_outlined,
            label: '$commentCount',
            onPressed: _handleComment,
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
}
