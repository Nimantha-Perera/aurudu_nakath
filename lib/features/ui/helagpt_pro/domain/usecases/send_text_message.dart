import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add intl package for date formatting

class SendTextMessageUseCase2 {
  final String apiKey;
  final String apiUrl;
  late final AudioPlayer audioPlayer;

  SendTextMessageUseCase2(this.apiKey, this.apiUrl) {
    audioPlayer = AudioPlayer();
  }

  Future<void> playMessageSentSound() async {
    try {
      await audioPlayer.play(AssetSource('sounds/send.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

 Future<String> sendMessage(String message) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> messageList = prefs.getStringList('messages') ?? [];
  List<int> sendTimes = _getIntList(prefs, 'sendTimes');

  DateTime now = DateTime.now();

  // Add new message and its send time
  if (messageList.length >= 10) {
    messageList.removeAt(0);
    sendTimes.removeAt(0);
  }
  messageList.add(message);
  sendTimes.add(now.millisecondsSinceEpoch);

  await prefs.setStringList('messages', messageList);
  _setIntList(prefs, 'sendTimes', sendTimes);

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
      Uri.parse(apiUrl),
      headers: header,
      body: jsonEncode(data),
    );

    // Play the sound effect when the message is sent
    await playMessageSentSound();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody != null &&
          responseBody['candidates'] != null &&
          responseBody['candidates'].isNotEmpty) {
        final candidate = responseBody['candidates'][0];
        final content = candidate['content'];
        final parts = content['parts'];

        if (parts != null && parts.isNotEmpty) {
          return parts[0]['text'] ?? 'No response text available';
        }
      }
    }
    return "Error in response: ${response.statusCode}";
  } catch (e) {
    return "Failed to connect: $e";
  }
}

  List<int> _getIntList(SharedPreferences prefs, String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<int>();
  }

  Future<void> _setIntList(
      SharedPreferences prefs, String key, List<int> list) async {
    final jsonString = jsonEncode(list);
    await prefs.setString(key, jsonString);
  }
}
