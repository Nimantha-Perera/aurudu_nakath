import 'package:aurudu_nakath/features/ui/permissions/permissions_hadler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:markdown/markdown.dart' as md;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ChatBubble extends StatefulWidget {
  final String message;
  final bool isMe;
  final Color backgroundColor;
  final Color textColor;
  final BorderRadius borderRadius;
  final String? imagePath;

  ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.backgroundColor,
    required this.textColor,
    required this.borderRadius,
    this.imagePath,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final PermissionHandler _permissionHandler = PermissionHandler();
  String? _localImagePath;

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

    if (widget.imagePath != null) {
      _saveImageLocally();
    }
  }

  Future<void> _saveImageLocally() async {
    await _permissionHandler.requestManageExternalStorage();
    if (widget.imagePath == null) return;

    try {
      final directory = await getTemporaryDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final localPath = '${directory.path}/$fileName';

      // Copy the image to temporary directory
      await File(widget.imagePath!).copy(localPath);

      if (mounted) {
        setState(() {
          _localImagePath = localPath;
        });
      }
    } catch (error) {
      print('Error saving image locally: $error');
    }
  }

  Future<void> _downloadImage() async {
    if (_localImagePath == null) return;

    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        final result = await ImageGallerySaver.saveFile(_localImagePath!);
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Image downloaded successfully!'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        } else {
          throw Exception('Failed to save image');
        }
      } catch (error) {
        print('Error saving image to gallery: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to download image.'),
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Storage permission denied.'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          action: SnackBarAction(
            label: 'Settings',
            onPressed: () async {
              // Open app settings
              await openAppSettings();
            },
            textColor: Colors.blue, // Customize text color as needed
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    // Clean up temporary image file
    if (_localImagePath != null) {
      File(_localImagePath!).delete().catchError((error) {
        print('Error deleting temporary image: $error');
      });
    }
    super.dispose();
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
                      if (_localImagePath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.file(
                                File(_localImagePath!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              Positioned(
                                right: 10,
                                bottom: 10,
                                child: IconButton(
                                  icon:
                                      Icon(Icons.download, color: Colors.white),
                                  onPressed: _downloadImage,
                                  tooltip: 'Download Image',
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_localImagePath != null && widget.message.isNotEmpty)
                        SizedBox(height: 8),
                      if (widget.message.isNotEmpty)
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
