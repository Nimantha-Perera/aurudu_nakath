class Post {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String auther_aveter;
  final String author;
  final DateTime? createdTime; // Change this to DateTime?

  Post({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.auther_aveter,
    required this.author,
    this.createdTime, // Make sure this is nullable
  });
}
