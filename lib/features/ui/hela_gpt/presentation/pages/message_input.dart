import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
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
  final GlobalKey _voiceInputKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _sendButtonAnimation;

  bool _tutorialShown = false;
  bool _isListening = false;

  final SpeechToText _speechToText = SpeechToText();
  String _wordSpoken = '';
  double _confidenceLevel = 0;

  @override
  void initState() {
    super.initState();
    _loadTutorialState();
    _setupAnimations();
    _initSpeechRecognition();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
  }

  Future<void> _initSpeechRecognition() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Speech recognition not available'),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
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
      TutorialHelper.createCustomTarget(
        identify: 'voice_input',
        keyTarget: _voiceInputKey,
        align: ContentAlign.top,
        text: 'මෙම බොත්තම ඔබා හඬ ඇතුළත් කිරීම ආරම්භ කරන්න. කතා කිරීම අවසන් වූ පසු ස්වයංක්‍රීයව යැවේ.',
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

  void _sendMessage([String? text]) {
    final message = text?.trim() ?? _controller.text.trim();
    if (message.isNotEmpty) {
      Provider.of<ChatViewModel>(context, listen: false).sendMessage(message);
      _controller.clear();
      _animationController.reverse();
    }
  }

  void _startListening() async {
    if (!_speechToText.isAvailable) return;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'si_LK',
    );

    setState(() {
      _isListening = true;
    });
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {
      _isListening = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordSpoken = result.recognizedWords;
      _confidenceLevel = result.confidence;
    });

    if (result.finalResult) {
      _stopListening();
      _sendMessage(_wordSpoken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildNewChatButton(),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(),
            ),
            const SizedBox(width: 12),
            _buildVoiceInputButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewChatButton() {
    return Container(
      key: _startNewChatKey,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        icon: Icon(
          Icons.refresh_rounded,
          color: Theme.of(context).primaryColor,
          size: 22,
        ),
        onPressed: _startNewChat,
        tooltip: 'Start New Chat',
        splashRadius: 24,
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade50
            : Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade600
                      : Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black87
                    : Colors.white,
                fontSize: 15,
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          AnimatedBuilder(
            animation: _sendButtonAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _sendButtonAnimation.value,
                child: child,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 4.0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  key: _sendButtonKey,
                  onTap: () => _sendMessage(),
                  customBorder: const CircleBorder(),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceInputButton() {
    return Container(
      decoration: BoxDecoration(
        color: _isListening
            ? Colors.red.withOpacity(0.1)
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: _isListening
              ? Colors.red.withOpacity(0.2)
              : Theme.of(context).primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: IconButton(
        key: _voiceInputKey,
        icon: Icon(
          _isListening ? Icons.mic_off_rounded : Icons.mic_rounded,
          color: _isListening ? Colors.red : Theme.of(context).primaryColor,
          size: 22,
        ),
        onPressed: _isListening ? _stopListening : _startListening,
        splashRadius: 24,
      ),
    );
  }
}