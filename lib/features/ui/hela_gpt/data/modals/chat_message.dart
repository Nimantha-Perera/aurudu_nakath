class ChatMessage {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  ChatMessage({
    required this.message,
    required this.isMe,
    required this.timestamp,
  });

  // Factory method to create ChatMessage from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] as String,
      isMe: json['isMe'] as bool,
      timestamp: DateTime.parse(json['timestamp']),  // Convert timestamp string back to DateTime
    );
  }

  // Convert ChatMessage to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'isMe': isMe,
      'timestamp': timestamp.toIso8601String(),  // Convert DateTime to string
    };
  }
}
