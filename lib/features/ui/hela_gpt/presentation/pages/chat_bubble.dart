import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius borderRadius;

  ChatBubble({
    required this.message,
    required this.isMe,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: MarkdownBody(
          data: message,
          styleSheet: MarkdownStyleSheet(
            p: TextStyle(
              color: textColor,
              fontSize: 16.0,  // Specify a default font size
            ),
            h1: TextStyle(
              color: textColor,
              fontSize: 24.0,  // Example font size for headers
            ),
            h2: TextStyle(
              color: textColor,
              fontSize: 22.0,  // Example font size for headers
            ),
            // You can add more styles for other Markdown elements if needed
          ),
        ),
      ),
    );
  }
}
