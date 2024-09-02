import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HelpTopicCard extends StatelessWidget {
  final String title;
  final String description;

  const HelpTopicCard({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 6.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D003B),
              ),
            ),
            const SizedBox(height: 8.0),
            MarkdownBody(
              data: description,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                  height: 1.4,
                ),
                listBullet: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
