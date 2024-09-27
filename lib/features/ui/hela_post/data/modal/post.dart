class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String author;
  final String auther_aveter;
  final DateTime? createdTime;
  late final int likeCount; // Add this field
  final String? userId;

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.author,
    required this.auther_aveter,
    required this.createdTime,
    this.likeCount = 0, // Initialize likeCount
    this.userId,
  });
}
