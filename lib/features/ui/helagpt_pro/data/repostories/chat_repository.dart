// data/repositories/chat_repository.dart




import 'package:aurudu_nakath/features/ui/helagpt_pro/data/modals/chat_message.dart';

abstract class ChatRepository {
  Future<void> sendMessage(ChatMessage message);
  Future<List<ChatMessage>> getMessages();
}

// data/datasources/chat_remote_data_source.dart
class ChatRemoteDataSource {
  Future<void> sendMessage(String message) async {
    // Call API to send a message
  }

  Future<List<ChatMessage>> getMessages() async {
    // Fetch messages from an API
    return []; // Placeholder
  }
}
