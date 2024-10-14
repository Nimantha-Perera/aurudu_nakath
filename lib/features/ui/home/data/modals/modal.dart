class Notice {
  final String? title;
  final String? subtitle;
  final DateTime? noticeTime; // Make this nullable

  Notice({
    required this.title,
    required this.subtitle,
    required this.noticeTime,
  });
}
