import 'package:shared_preferences/shared_preferences.dart';

class ClearChatHistoryUseCase2 {
  final SharedPreferences _prefs;

  ClearChatHistoryUseCase2(this._prefs);

  Future<void> clearChat() async {
    await _prefs.remove('chat_messages');
  }
}