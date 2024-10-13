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
      duration: const Duration(milliseconds: 200),
    );
    _sendButtonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initSpeechRecognition() async {
    bool available = await _speechToText.initialize();
    if (!available) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Speech recognition not available')),
      );
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
      localeId: 'si_LK', // Set Sinhala locale
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildNewChatButton(),
            const SizedBox(width: 12),
            Expanded(
              child: _buildInputField(),
            ),
            const SizedBox(width: 8),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        icon: Icon(Icons.refresh, color: Theme.of(context).primaryColor),
        onPressed: _startNewChat,
        tooltip: 'Start New Chat',
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.grey.shade200,
        borderRadius: BorderRadius.circular(24.0),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1.5,
        ),
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
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                hintStyle: TextStyle(color: Colors.grey.shade600),
              ),
              style: TextStyle(color: Colors.black87),
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
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
    return IconButton(
      key: _voiceInputKey,
      icon: Icon(
        _isListening ? Icons.mic_off : Icons.mic,
        color: _isListening ? Colors.red : Theme.of(context).primaryColor,
      ),
      onPressed: _isListening ? _stopListening : _startListening,
    );
  }
}
