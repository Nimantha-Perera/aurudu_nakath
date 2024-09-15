import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius borderRadius;

  ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.message));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('පෙළ පසුරු පුවරුවට පිටපත් කරන ලදී'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Align(
        alignment: widget.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Card(
            color: widget.backgroundColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1),
            ),
            child: InkWell(
              onLongPress: () => _copyToClipboard(context),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MarkdownBody(
                      data: widget.message,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(color: widget.textColor, fontSize: 16.0),
                        h1: TextStyle(color: widget.textColor, fontSize: 24.0, fontWeight: FontWeight.bold),
                        h2: TextStyle(color: widget.textColor, fontSize: 22.0, fontWeight: FontWeight.bold),
                        code: TextStyle(backgroundColor: Colors.grey.withOpacity(0.2), fontFamily: 'monospace'),
                        codeblockPadding: EdgeInsets.all(8),
                        codeblockDecoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onTapLink: (text, url, title) {
                        if (url != null) {
                          _launchURL(url);
                        }
                      },
                      builders: {
                        'code': CustomCodeBlockBuilder(),
                      },
                    ),
                    SizedBox(height: 4),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${DateTime.now().hour}:${DateTime.now().minute}',
                        style: TextStyle(color: widget.textColor.withOpacity(0.6), fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomCodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    if (element.tag != 'code') return null;

    String language = '';
    
    // Check if the element has any classes
    if (element.attributes['class'] != null) {
      final classes = element.attributes['class']!.split(' ');
      for (final className in classes) {
        if (className.startsWith('language-')) {
          language = className.substring(9);
          break;
        }
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (language.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                language,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          SelectableText(
            element.textContent,
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}