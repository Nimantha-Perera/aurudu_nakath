import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
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
                fontSize: 16.0,
              ),
              h1: TextStyle(
                color: textColor,
                fontSize: 24.0,
              ),
              h2: TextStyle(
                color: textColor,
                fontSize: 22.0,
              ),
              // Add more styles for other Markdown elements if needed
            ),
            onTapLink: (text, url, title) {
              if (url != null) {
                _launchURL(url);
              }
            },
          ),
        ),
      ),
    );
  }
}
