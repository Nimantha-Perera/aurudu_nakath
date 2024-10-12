import 'dart:convert';
import 'dart:io';
import 'package:aurudu_nakath/features/ui/helagpt_pro/data/modals/chat_message.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_generated_img.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/domain/usecases/send_text_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatViewModel with ChangeNotifier {
  final FetchManageMessagesUseCase2 _fetchManageMessagesUseCase;
  final SendTextMessageUseCase2 _sendTextMessageUseCase;
  final SendImageMessageUseCase2 _sendImageMessageUseCase;
  final ClearChatHistoryUseCase2 _clearChatHistoryUseCase;
  final SendGeneratedImageMessageUseCase2 _sendGeneratedImageUseCase;

  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatViewModel(
    this._fetchManageMessagesUseCase,
    this._sendTextMessageUseCase,
    this._sendImageMessageUseCase,
    this._clearChatHistoryUseCase,
    this._sendGeneratedImageUseCase,
  );

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  // Fetch messages from storage
  Future<void> fetchMessages() async {
    _messages = await _fetchManageMessagesUseCase.fetchMessages();
    notifyListeners();
  }

  // Send a text message or generate an image based on the input
  Future<void> sendMessage(String message) async {
    _isTyping = true;
    notifyListeners();

    // Add user message to the chat
    _messages.add(ChatMessage(
      message: message,
      isMe: true,
      timestamp: DateTime.now(),
    ));

    // Check if the message contains keywords for image generation
    if (_isGenerateCommand(message)) {
      try {
        // Generate an image from the text
        File generatedImageFile =
            await _sendGeneratedImageUseCase.generateImageFromText(message);

        // Use the path of the generated image file
        String generatedImagePath = generatedImageFile.path;

        _messages.add(ChatMessage(
          message: 'ඔබ ඉල්ලූ ජායාරූපය',
          imagePath:
              generatedImagePath, // Add the path of the generated image to the chat
          isMe: false,
          timestamp: DateTime.now(),
        ));
      } catch (e) {
        _messages.add(ChatMessage(
          message: 'සමාවෙන්න යම්කිසි ගැටලුවක්, යෙදුම නැවත ආරම්භ කර නැවත උත්සාහ කරන්න $e',
          isMe: false,
          timestamp: DateTime.now(),
        ));
      }
    } else {
      // Send normal text message and get the response
      String response = await _sendTextMessageUseCase.sendTextToGemini(message);
      _messages.add(ChatMessage(
        message: response,
        isMe: false,
        timestamp: DateTime.now(),
      ));
    }

    _isTyping = false;
    await _saveMessages();
    notifyListeners();
  }

  // Helper function to check if the message contains a command to generate an image
  bool _isGenerateCommand(String message) {
    final generateKeywords = ['generate', 'අඳින්න','උත්පාදනය කරන්න','ජායාරූපය'];
    return generateKeywords
        .any((keyword) => message.toLowerCase().contains(keyword));
  }

  // Send an image with accompanying text
  Future<void> sendImage(XFile image, String text) async {
    _isTyping = true;
    notifyListeners();

    // Add the image and text to the chat
    _messages.add(ChatMessage(
      message: text,
      isMe: true,
      timestamp: DateTime.now(),
      imagePath: image.path,
    ));

    // Send the image and handle response
    final response =
        await _sendImageMessageUseCase.sendImageWithText(image, text);
    _messages.add(ChatMessage(
      message: response,
      isMe: false,
      timestamp: DateTime.now(),
    ));

    _isTyping = false;
    await _saveMessages();
    notifyListeners();
  }

  // Clear chat history
  Future<void> clearChat() async {
    await _clearChatHistoryUseCase.clearChat();
    _messages.clear();
    notifyListeners();
  }

  // Save messages to storage
  Future<void> _saveMessages() async {
    await _fetchManageMessagesUseCase.saveMessages(_messages);
  }
}

// Dependency Injection setup
Future<List<SingleChildStatelessWidget>> setupDependencies() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";

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
    Provider<SendGeneratedImageMessageUseCase2>(
      create: (_) => SendGeneratedImageMessageUseCase2(apiKey),
    ),
    ChangeNotifierProxyProvider4<
        FetchManageMessagesUseCase2,
        SendTextMessageUseCase2,
        SendImageMessageUseCase2,
        ClearChatHistoryUseCase2,
        ChatViewModel>(
      create: (context) => ChatViewModel(
        context.read<FetchManageMessagesUseCase2>(),
        context.read<SendTextMessageUseCase2>(),
        context.read<SendImageMessageUseCase2>(),
        context.read<ClearChatHistoryUseCase2>(),
        context.read<SendGeneratedImageMessageUseCase2>(),
      ),
      update:
          (context, fetchManage, sendText, sendImage, clearChat, previous) =>
              previous ??
              ChatViewModel(fetchManage, sendText, sendImage, clearChat,
                  context.read<SendGeneratedImageMessageUseCase2>()),
    ),
  ];
}
