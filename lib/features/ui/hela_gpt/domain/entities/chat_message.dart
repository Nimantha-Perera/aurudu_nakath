class ChatMessage {
  final String message;
  final bool isMe;
  final DateTime timestamp; // Add this field

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.timestamp, // Initialize timestamp
  });
}
