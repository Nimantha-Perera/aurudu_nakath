
import 'package:aurudu_nakath/features/ui/helagpt_pro/data/modals/chat_message.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nested/nested.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 2. Create your ChatViewModel
class ChatViewModel with ChangeNotifier {
  final FetchManageMessagesUseCase2 _fetchManageMessagesUseCase;
  final SendTextMessageUseCase2 _sendTextMessageUseCase;
  final SendImageMessageUseCase2 _sendImageMessageUseCase;
  final ClearChatHistoryUseCase2 _clearChatHistoryUseCase;

  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatViewModel(
    this._fetchManageMessagesUseCase,
    this._sendTextMessageUseCase,
    this._sendImageMessageUseCase,
    this._clearChatHistoryUseCase,
  );

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> fetchMessages() async {
    _messages = await _fetchManageMessagesUseCase.fetchMessages();
    notifyListeners();
  }

Future<void> sendMessage(String message) async {
  _isTyping = true;
  notifyListeners();

  _messages.add(ChatMessage(message: message, isMe: true, timestamp: DateTime.now()));

  // Simulate a delay for auto-replies and real responses
  await Future.delayed(Duration(seconds: 1));

  String response;
  if (_isAutoReply(message)) {
    response = 'හෙලෝ මම හෙළ GPT ඉතා විශාල භාශා අකෘතියක්. ඔබට ඇති ඕනෑම ගැටලුවක් මගෙන් අහන්න පුලුවන් මම ඔබට උපකාර කරන්නම්';
  } else {
    response = await _sendTextMessageUseCase.sendTextToGemini(message);
  }

  _messages.add(ChatMessage(message: response, isMe: false, timestamp: DateTime.now()));

  _isTyping = false;
  await _fetchManageMessagesUseCase.saveMessages(_messages);
  notifyListeners();
}

bool _isAutoReply(String message) {
  final autoReplyKeywords = [
    'who are you',
    'ඔයා කවුද',
    'ඔයා',
    'oya kwd',
    'oya',
  ];
  return autoReplyKeywords.any((keyword) => message.toLowerCase().contains(keyword));
}


  Future<void> sendImage(XFile image, String text) async {
    _isTyping = true;
    notifyListeners();

    _messages.add(ChatMessage(message:text, isMe: true, timestamp: DateTime.now()));
    
    final response = await _sendImageMessageUseCase.sendImageWithText(image, text);
    
    
    _messages.add(ChatMessage(message: response, isMe: false, timestamp: DateTime.now()));
    
    _isTyping = false;
    await _fetchManageMessagesUseCase.saveMessages(_messages);
    notifyListeners();
  }

  Future<void> clearChat() async {
    await _clearChatHistoryUseCase.clearChat();
    _messages.clear();
    notifyListeners();
  }
}

// 3. Set up dependency injection in your main.dart or a separate file
Future<List<SingleChildStatelessWidget>> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final apiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

  return [
    Provider<FetchManageMessagesUseCase2>(
      create: (_) => FetchManageMessagesUseCase2(sharedPreferences),
    ),
    Provider<SendTextMessageUseCase2>(
      create: (_) => SendTextMessageUseCase2(apiKey, apiUrl),
    ),
    Provider<SendImageMessageUseCase2>(
      create: (_) => SendImageMessageUseCase2(apiKey),
    ),
    Provider<ClearChatHistoryUseCase2>(
      create: (_) => ClearChatHistoryUseCase2(sharedPreferences),
    ),
    ChangeNotifierProxyProvider4<FetchManageMessagesUseCase2, SendTextMessageUseCase2, 
    SendImageMessageUseCase2, ClearChatHistoryUseCase2, ChatViewModel>(
  create: (context) => ChatViewModel(
    context.read<FetchManageMessagesUseCase2>(),
    context.read<SendTextMessageUseCase2>(),
    context.read<SendImageMessageUseCase2>(),
    context.read<ClearChatHistoryUseCase2>(),
  ),
  update: (context, fetchManage, sendText, sendImage, clearChat, previous) =>
    previous ?? ChatViewModel(fetchManage, sendText, sendImage, clearChat),
),

  ];
}

// 4. Use the ChatViewModel in your UI
class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Chat')),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.messages.length,
                  itemBuilder: (context, index) {
                    final message = viewModel.messages[index];
                    return ListTile(
                      title: Text(message.message),
                      subtitle: Text(message.isMe ? 'You' : 'Bot'),
                    );
                  },
                ),
              ),
              if (viewModel.isTyping) CircularProgressIndicator(),
              MessageInput(), // Add MessageInput widget
            ],
          ),
        );
      },
    );
  }
}

// 5. Initialize in your main.dart
