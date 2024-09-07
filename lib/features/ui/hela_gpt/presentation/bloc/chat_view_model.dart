import 'dart:convert';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/entities/chat_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/get_messages.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class ChatViewModel with ChangeNotifier {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatViewModel(this._getMessagesUseCase, this._sendMessageUseCase);

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> fetchMessages() async {
    _messages = await _getMessagesUseCase.getMessages();
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
  // Add user message to history
  _messages.add(ChatMessage(message: message, isMe: true, timestamp: DateTime.now()));
  notifyListeners();

  // Send message logic (e.g., saving to the database)
  await _sendMessageUseCase.sendMessage(message);

  // Simulate bot typing
  _isTyping = true;
  notifyListeners();

  // Send request to Gemini API
  final apiKey = dotenv.env['API_KEY'] ?? "";
  final ourUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
  final header = {'Content-Type': 'application/json'};

  final data = {
    "contents": [
      {
        "parts": [
          {"text": message}
        ]
      }
    ],
    "generationConfig": {
       // Specify Sinhala as the target language
    }
  };

  try {
    final response = await http.post(
      Uri.parse(ourUrl),
      headers: header,
      body: jsonEncode(data),
    );

    // Debug: Print the response body
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // Parse the API response
      final responseBody = jsonDecode(response.body);

      // Check if the response body contains the expected data
      if (responseBody != null &&
          responseBody['candidates'] != null &&
          responseBody['candidates'].isNotEmpty) {

        final candidate = responseBody['candidates'][0];
        final content = candidate['content'];
        final parts = content['parts'];

        if (parts != null && parts.isNotEmpty) {
          final text = parts[0]['text'];

          // Check for null or empty text
          final botMessage = text ?? 'No response text available';

          // Add bot response to chat
          _isTyping = false;
          _messages.add(ChatMessage(message: botMessage, isMe: false, timestamp: DateTime.now()));
        } else {
          // Handle case where 'parts' is null or empty
          _isTyping = false;
          _messages.add(ChatMessage(message: "No text found in response", isMe: false, timestamp: DateTime.now()));
        }
      } else {
        // Handle case where 'candidates' is null or empty
        _isTyping = false;
        _messages.add(ChatMessage(message: "No valid response from API", isMe: false, timestamp: DateTime.now()));
      }
    } else {
      // Handle API errors
      _isTyping = false;
      _messages.add(ChatMessage(message: "Error in response: ${response.statusCode}", isMe: false, timestamp: DateTime.now()));
    }
  } catch (e) {
    // Handle any exceptions
    _isTyping = false;
    _messages.add(ChatMessage(message: "Failed to connect: $e", isMe: false, timestamp: DateTime.now()));
  }

  notifyListeners();
}

}
