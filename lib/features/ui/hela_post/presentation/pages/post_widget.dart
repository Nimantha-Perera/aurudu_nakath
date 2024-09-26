import 'package:aurudu_nakath/features/ui/hela_post/data/modal/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'post_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> with SingleTickerProviderStateMixin {
  bool isLiked = false;
  List<String> comments = [];
  final TextEditingController commentController = TextEditingController();
  bool showComments = false;
  bool isDescriptionExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _fetchComments();
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
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildImage(),
          _buildContent(),
          _buildFooter(),
          _buildCommentSection(),
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
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {},
          ),
        ],
      ),
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
          borderRadius: BorderRadius.circular(16),
          child: CachedNetworkImage(
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
                if (isDescriptionExpanded) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
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
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTruncatedDescription() {
    const int maxLength = 100;
    if (widget.post.description.length > maxLength) {
      return '${widget.post.description.substring(0, maxLength)}...';
    }
    return widget.post.description;
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildInteractionButton(
            isLiked ? Icons.favorite : Icons.favorite_border,
            '${widget.post.likeCount}',
            onPressed: () {
              setState(() {
                isLiked = !isLiked;
                _updateLikeCount(widget.post);
              });
            },
            color: isLiked ? Colors.red : null,
          ),
          _buildInteractionButton(
            Icons.comment_outlined,
            '${comments.length}',
            onPressed: () {
              setState(() {
                showComments = !showComments;
              });
            },
          ),
          _buildInteractionButton(Icons.share_outlined, 'Share'),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(IconData icon, String label, {VoidCallback? onPressed, Color? color}) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? Colors.grey[700]),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: showComments ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      firstChild: Container(),
      secondChild: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Comments', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            comments.isEmpty
                ? Text('No comments yet', style: TextStyle(color: Colors.grey[600]))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Text(
                          comments[index],
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      );
                    },
                  ),
            const SizedBox(height: 8),
            _buildCommentInput(),
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
              hintText: 'Write a comment...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
          onPressed: () {
            _addComment(commentController.text);
          },
        ),
      ],
    );
  }

  Future<void> _updateLikeCount(Post post) async {
    int newLikeCount = isLiked ? post.likeCount + 1 : post.likeCount - 1;

    await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
      'likeCount': newLikeCount,
    });
  }

  Future<void> _fetchComments() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.id)
          .collection('comments')
          .get();

      setState(() {
        comments = snapshot.docs.map((doc) => doc['text'] as String).toList();
      });
    } catch (e) {
      print('Error fetching comments: $e');
    }
  }

  Future<void> _addComment(String comment) async {
    if (comment.isNotEmpty) {
      try {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.post.id)
            .collection('comments')
            .add({'text': comment});

        commentController.clear();
        _fetchComments();
      } catch (e) {
        print('Error adding comment: $e');
      }
    }
  }
}