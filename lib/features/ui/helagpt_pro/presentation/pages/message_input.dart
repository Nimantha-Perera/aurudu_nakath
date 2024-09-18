import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/bloc/chat_view_model.dart';
import 'package:aurudu_nakath/features/ui/tutorial/tutorial_coach_mark.dart';

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _inputFieldKey = GlobalKey();
  final GlobalKey _startNewChatKey = GlobalKey();

  List<TargetFocus> targets = [];
  XFile? _selectedImage;
  bool _tutorialShown = false;

  @override
  void dispose() {
    _controller.dispose();
    _textNotifier.dispose();
    super.dispose();
  }

  void _startNewChat() {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    chatViewModel.clearChat();
    _controller.clear();
    _textNotifier.value = '';
    _selectedImage = null;
  }

  Future<void> _loadTutorialState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tutorialShown = prefs.getBool('tutorial_chat_input_shown') ?? false;
    });

    if (!_tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial());
    }
  }

  Future<void> _setTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_chat_input_shown', true);
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _showTutorial() {
    setState(() {
      targets = [
        TutorialHelper.createCustomTarget(
          identify: "input_field",
          keyTarget: _inputFieldKey,
          text: "අවශ්‍ය දේ මෙහි ලියන්න හෝ රූපයක් තෝරන්න",
          align: ContentAlign.top,
          shape: ShapeLightFocus.RRect,
        ),
        TutorialHelper.createCustomTarget(
          identify: 'start_new_chat',
          keyTarget: _startNewChatKey,
          align: ContentAlign.top,
          text: 'මෙම බොත්තම එබීමෙන් නව කතාබහක් ආරම්භ කරන්න.',
          shape: ShapeLightFocus.Circle,
        ),
      ];

      TutorialHelper.showTutorial(
        context: context,
        targets: targets,
      );

      _setTutorialShown();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTutorialState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_selectedImage != null)
            Container(
              height: 100,
              width: double.infinity,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: FileImage(File(_selectedImage!.path)),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => setState(() => _selectedImage = null),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  key: _inputFieldKey,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
                        onPressed: _pickImage,
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (text) => _textNotifier.value = text,
                          decoration: InputDecoration(
                            hintText: 'අවශ්‍ය දේ මෙහි ලියන්න...',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: _textNotifier,
                        builder: (context, text, child) {
                          return AnimatedOpacity(
                            opacity: (text.isNotEmpty || _selectedImage != null) ? 1.0 : 0.5,
                            duration: Duration(milliseconds: 200),
                            child: IconButton(
                              icon: Icon(Icons.send, color: Theme.of(context).primaryColor),
                              onPressed: (text.isNotEmpty || _selectedImage != null)
                                  ? () {
                                      if (_selectedImage != null) {
                                        Provider.of<ChatViewModel>(context, listen: false)
                                            .sendImage(_selectedImage!, text);
                                        setState(() => _selectedImage = null);
                                      } else {
                                        Provider.of<ChatViewModel>(context, listen: false)
                                            .sendMessage(text);
                                      }
                                      _controller.clear();
                                      _textNotifier.value = '';
                                    }
                                  : null,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12),
              FloatingActionButton(
                key: _startNewChatKey,
                mini: true,
                child: Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimary),
                onPressed: _startNewChat,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}