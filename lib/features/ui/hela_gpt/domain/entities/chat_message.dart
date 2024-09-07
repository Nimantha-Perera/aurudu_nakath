class ChatMessage {
  final String message;
  final bool isMe;
  final DateTime timestamp;
  final bool isMarkdown; // New field

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.timestamp,
    this.isMarkdown = false, // Default to false
  });
}

