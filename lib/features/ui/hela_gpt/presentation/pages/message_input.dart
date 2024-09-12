import 'package:aurudu_nakath/features/ui/tutorial/tutorial_coach_mark.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _sendButtonKey = GlobalKey();
  final GlobalKey _textFieldKey = GlobalKey();
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

    // Show tutorial if not already shown
    if (!_tutorialShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTutorial(); // Show tutorial after the widget is built
      });
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
          identify: "text_field",
          keyTarget: _textFieldKey,
          text: "අවශ්‍ය දේ මෙහි ලියන්න",
          align: ContentAlign.top,
          shape: ShapeLightFocus.RRect,
        ),
        TutorialHelper.createCustomTarget(
          identify: 'send_button',
          keyTarget: _sendButtonKey,
          align: ContentAlign.top,
          text: 'පසුව මෙම බටනය ක්ලික් කරන්න',
          shape: ShapeLightFocus.Circle,
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

      _setTutorialShown(); // Set the tutorial as shown after completion
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTutorialState(); // Ensure tutorial state is loaded
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_selectedImage != null)
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                margin: const EdgeInsets.only(bottom: 8.0),
                constraints: BoxConstraints(
                  maxHeight: 100,
                  maxWidth: double.infinity,
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.file(
                  File(_selectedImage!.path),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.add, color: const Color.fromARGB(255, 94, 94, 94)),
                onPressed: _startNewChat,
                key: _startNewChatKey,
              ),
              Expanded(
                child: TextField(
                  key: _textFieldKey,
                  controller: _controller,
                  onChanged: (text) {
                    _textNotifier.value = text;
                  },
                  decoration: InputDecoration(
                    hintText: 'අවශ්‍ය දේ මෙහි ලියන්න...',
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ValueListenableBuilder<String>(
                valueListenable: _textNotifier,
                builder: (context, text, child) {
                  return CircleAvatar(
                    key: _sendButtonKey,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: IconButton(
                      icon: Icon(Icons.send, color: Theme.of(context).secondaryHeaderColor),
                      onPressed: (text.isNotEmpty || _selectedImage != null)
                          ? () {
                              if (_selectedImage != null) {
                                Provider.of<ChatViewModel>(context, listen: false)
                                    .sendImage(_selectedImage!, text);
                                setState(() {
                                  _selectedImage = null;
                                });
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
        ],
      ),
    );
  }
}
