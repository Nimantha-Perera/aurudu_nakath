import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_tts/flutter_tts.dart';

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

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  FlutterTts flutterTts = FlutterTts();

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

    if (!widget.isMe) {
      _initTts();
    }
  }

Future<void> _initTts() async {
  try {
    // Initialize the TTS engine
    await flutterTts.awaitSpeakCompletion(true); // Ensure TTS is bound properly

    // Check if the TTS engine is installed
    bool isInstalled = await flutterTts.isLanguageAvailable("si-LK"); // Check with a common language like English
    if (!isInstalled) {
      print("TTS engine is not installed on this device.");
      return;
    }

    // Set the language to Sinhala (or any other fallback if not available)
    await flutterTts.setLanguage("si-LK");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);

    // Check if Sinhala is available
    bool isLanguageAvailable = await flutterTts.isLanguageAvailable("si-LK");
    if (isLanguageAvailable) {
      print("Sinhala language is available");
      await flutterTts.speak("හෙලෝ! කොහොමද?");
    } else {
      print("Sinhala language is not available on this device.");
    }
  } catch (e) {
    print("TTS initialization failed: $e");
  }
}



  @override
  void dispose() {
    _animationController.dispose();
    flutterTts.stop();
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
            elevation: 3,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: widget.borderRadius,
            ),
            child: InkWell(
              onLongPress: () => _copyToClipboard(context),
              borderRadius: widget.borderRadius,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.backgroundColor.withOpacity(0.95),
                      widget.backgroundColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: widget.borderRadius,
                ),
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MarkdownBody(
                        data: widget.message,
                        styleSheet: MarkdownStyleSheet(
                          p: TextStyle(
                            color: widget.textColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                          ),
                          h1: TextStyle(
                            color: widget.textColor,
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          h2: TextStyle(
                            color: widget.textColor,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                          ),
                          code: TextStyle(
                            backgroundColor: Colors.grey.withOpacity(0.2),
                            fontFamily: 'monospace',
                            color: widget.textColor.withOpacity(0.9),
                          ),
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
                      SizedBox(height: 6),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                          style: TextStyle(
                            color: widget.textColor.withOpacity(0.6),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
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
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}