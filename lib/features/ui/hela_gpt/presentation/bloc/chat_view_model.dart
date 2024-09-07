import 'dart:convert';
import 'dart:io';
import 'package:aurudu_nakath/features/ui/hela_gpt/data/modals/chat_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/get_messages.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatViewModel with ChangeNotifier {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  List<ChatMessage> _messages = [];
  bool _isTyping = false;

  ChatViewModel(this._getMessagesUseCase, this._sendMessageUseCase);

  List<ChatMessage> get messages => _messages;
  bool get isTyping => _isTyping;

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedMessages = prefs.getString('chat_messages');

    if (savedMessages != null) {
      List<dynamic> messageList;
      try {
        messageList = jsonDecode(savedMessages);
      } catch (e) {
        print('Error decoding saved messages: $e');
        messageList = [];
      }

      _messages = messageList
          .map((messageJson) {
            if (messageJson is String) {
              try {
                final Map<String, dynamic> messageMap = jsonDecode(messageJson);
                return ChatMessage.fromJson(messageMap);
              } catch (e) {
                print('Error parsing message: $e');
                return null;
              }
            } else if (messageJson is Map<String, dynamic>) {
              return ChatMessage.fromJson(messageJson);
            } else {
              print('Unexpected message format: $messageJson');
              return null;
            }
          })
          .whereType<ChatMessage>()
          .toList();
    } else {
      _messages = await _getMessagesUseCase.getMessages();
    }

    notifyListeners();
  }

  Future<void> saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messageJsonList =
        _messages.map((message) => jsonEncode(message.toJson())).toList();
    prefs.setString('chat_messages', jsonEncode(messageJsonList));
  }

  Future<void> clearChat() async {
    _messages.clear();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_messages');
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    _messages.add(
        ChatMessage(message: message, isMe: true, timestamp: DateTime.now()));
    notifyListeners();

    _isTyping = true;
    notifyListeners();

    final apiKey = dotenv.env['API_KEY'] ?? "";
    final ourUrl =
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey";
    final header = {'Content-Type': 'application/json'};

    final lastMessage = _messages.isNotEmpty ? _messages.last.message : '';

    final data = {
      "contents": [
        {
          "parts": [
            {"text": lastMessage}
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

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody != null &&
            responseBody['candidates'] != null &&
            responseBody['candidates'].isNotEmpty) {
          final candidate = responseBody['candidates'][0];
          final content = candidate['content'];
          final parts = content['parts'];

          if (parts != null && parts.isNotEmpty) {
            final text = parts[0]['text'] ?? 'No response text available';
            _messages.add(ChatMessage(
                message: text, isMe: false, timestamp: DateTime.now()));
          } else {
            _messages.add(ChatMessage(
                message: "No text found in response",
                isMe: false,
                timestamp: DateTime.now()));
          }
        } else {
          _messages.add(ChatMessage(
              message: "No valid response from API",
              isMe: false,
              timestamp: DateTime.now()));
        }
      } else {
        _messages.add(ChatMessage(
            message: "Error in response: ${response.statusCode}",
            isMe: false,
            timestamp: DateTime.now()));
      }
    } catch (e) {
      _messages.add(ChatMessage(
          message: "Failed to connect: $e",
          isMe: false,
          timestamp: DateTime.now()));
    }

    _isTyping = false;
    saveMessages();
    notifyListeners();
  }

  Future<void> sendImage(XFile image, String text) async {
    _messages.add(
        ChatMessage(message: 'Image selected', isMe: true, timestamp: DateTime.now()));
    notifyListeners();

    _isTyping = true;
    notifyListeners();

    final apiKey = dotenv.env['API_KEY'] ?? "";
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

     final prompt = TextPart(text);
       final imageBytes = await image.readAsBytes();
       final imagePart = DataPart('image/jpeg', imageBytes);
      

      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

    if (response != null) {
      final textResponse = response.text ?? 'No response text available';

      print(textResponse);
      _messages.add(ChatMessage(
          message: textResponse, isMe: false, timestamp: DateTime.now()));
    } else {
      _messages.add(ChatMessage(
          message: "No valid response from API",
          isMe: false,
          timestamp: DateTime.now()));
    }

    _isTyping = false;
    saveMessages();
    notifyListeners();
  }
}

