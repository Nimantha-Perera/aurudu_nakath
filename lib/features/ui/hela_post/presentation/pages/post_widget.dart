import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/fetch_comment_count.dart';
import 'package:aurudu_nakath/features/ui/hela_post/domain/usecase/like.dart';
import 'package:aurudu_nakath/features/ui/hela_post/presentation/pages/widget/comments.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'post_detail_screen.dart';


class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with SingleTickerProviderStateMixin {
  final FetchCommentCountUseCase _fetchCommentCountUseCase = FetchCommentCountUseCase();
  final LikeCountUseCase _likeCountUseCase = LikeCountUseCase();
  
  bool isLiked = false;
  late int likeCount;
  int commentCount = 0;
  bool showComments = false;
  bool isDescriptionExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchCommentCount();
    likeCount = widget.post.likeCount;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
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
            backgroundImage: CachedNetworkImageProvider(widget.post.auther_aveter),
            radius: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.post.author,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  widget.post.createdTime != null
                      ? DateFormat('MMM d, yyyy • HH:mm').format(widget.post.createdTime!)
                      : 'Date not available',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
          _buildReportButton(),
        ],
      ),
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
          builder: (context) => PostDetailScreen(post: widget.post),
        ),
      );
    },
    child: Hero(
      tag: 'postImage${widget.post.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0), // Add border radius if desired
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
          : Container(
             
            ),
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
            data: isDescriptionExpanded ? widget.post.description : _getTruncatedDescription(),
            styleSheet: MarkdownStyleSheet(
              p: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              setState(() {
                isDescriptionExpanded = !isDescriptionExpanded;
                isDescriptionExpanded ? _animationController.forward() : _animationController.reverse();
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isDescriptionExpanded ? 'Show Less' : 'Show More',
                  style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                ),
                RotationTransition(
                  turns: _animation,
                  child: Icon(Icons.keyboard_arrow_down, color: Theme.of(context).primaryColor),
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
          label: _formatCount(likeCount), // Use the new helper function
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
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(icon, size: 24, color: color ?? Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color ?? Colors.grey[700],
                ),
              ),
            ],
          ),
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
    if (widget.post.description.length > maxLength) {
      return '${widget.post.description.substring(0, maxLength)}...';
    }
    return widget.post.description;
  }

  Future<void> _fetchCommentCount() async {
  int count = await _fetchCommentCountUseCase.fetchCommentCount(widget.post.id);
  // Check if the widget is still mounted before calling setState
  if (mounted) {
    setState(() {
      commentCount = count;
    });
  }
}

}