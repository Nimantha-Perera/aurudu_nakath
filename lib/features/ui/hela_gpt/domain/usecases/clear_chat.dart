import 'package:shared_preferences/shared_preferences.dart';

class ClearChatHistoryUseCase {
  final SharedPreferences _prefs;

  ClearChatHistoryUseCase(this._prefs);

  Future<void> clearChat() async {
    await _prefs.remove('chat_messages');
  }
}