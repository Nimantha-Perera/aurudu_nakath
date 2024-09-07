import 'package:aurudu_nakath/features/ui/hela_gpt/domain/entities/chat_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/get_messages.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_message.dart';
import 'package:flutter/material.dart';
class ChatViewModel with ChangeNotifier {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  List<ChatMessage> _messages = [];
  bool _isTyping = false; // Track if the bot is typing

  ChatViewModel(this._getMessagesUseCase, this._sendMessageUseCase);

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> fetchMessages() async {
    _messages = await _getMessagesUseCase.getMessages();
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    // Add user message
    _messages.add(ChatMessage(message: message, isMe: true, timestamp: DateTime.now()));
    notifyListeners();

    // Send message logic (e.g., saving to the database)
    await _sendMessageUseCase.sendMessage(message);

    // Simulate bot typing for 1 second
    _isTyping = true;
    notifyListeners();

    Future.delayed(Duration(seconds: 1), () {
      _isTyping = false; // Stop typing
      _messages.add(ChatMessage(message: "Hi", isMe: false, timestamp: DateTime.now())); // Bot response
      notifyListeners();
    });
  }
}