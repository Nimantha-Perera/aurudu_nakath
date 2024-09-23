import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_text_message.dart';
import '../../../tutorial/tutorial_coach_mark.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({Key? key}) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey _sendButtonKey = GlobalKey();
  final GlobalKey _textFieldKey = GlobalKey();
  final GlobalKey _startNewChatKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _sendButtonAnimation;

  bool _tutorialShown = false;

  @override
  void initState() {
    super.initState();
    _loadTutorialState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
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

  void _showTutorial() {
    final targets = [
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

    TutorialHelper.showTutorial(context: context, targets: targets);
    _setTutorialShown();
  }

  Future<void> _startNewChat() async {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    chatViewModel.clearChat();
    await Provider.of<SendTextMessageUseCase>(context, listen: false).clearConversationHistory();
    _controller.clear();
    _animationController.reverse();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      Provider.of<ChatViewModel>(context, listen: false).sendMessage(text);
      _controller.clear();
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              key: _startNewChatKey,
              icon: const Icon(Icons.refresh),
              onPressed: _startNewChat,
              tooltip: 'Start New Chat',
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: _textFieldKey,
                        controller: _controller,
                        onChanged: (text) {
                          if (text.isNotEmpty) {
                            _animationController.forward();
                          } else {
                            _animationController.reverse();
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'අවශ්‍ය දේ මෙහි ලියන්න...',
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _sendButtonAnimation,
                      child: Container(
                        margin: const EdgeInsets.only(right: 4.0),
                        child: IconButton(
                          key: _sendButtonKey,
                          icon: const Icon(Icons.send),
                          onPressed: _sendMessage,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}