import 'dart:convert';

import 'package:aurudu_nakath/features/ui/hela_gpt/data/modals/chat_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FetchManageMessagesUseCase {
  final SharedPreferences _prefs;

  FetchManageMessagesUseCase(this._prefs);

  Future<List<ChatMessage>> fetchMessages() async {
    String? savedMessages = _prefs.getString('chat_messages');

    if (savedMessages != null) {
      List<dynamic> messageList = jsonDecode(savedMessages);
      return messageList
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
      return [];
    }
  }

  Future<void> saveMessages(List<ChatMessage> messages) async {
    List<String> messageJsonList =
        messages.map((message) => jsonEncode(message.toJson())).toList();
    _prefs.setString('chat_messages', jsonEncode(messageJsonList));
  }
}