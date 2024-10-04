import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class ClearChatHistoryUseCase2 {
  final SharedPreferences _prefs;
  String? _localImagePath;

  ClearChatHistoryUseCase2(this._prefs);

  Future<void> clearChat() async {
    await _prefs.remove('chat_messages');
    if (_localImagePath != null) {
      File(_localImagePath!).delete().catchError((error) {
        print('Error deleting temporary image: $error');
      });
    }
  }
}