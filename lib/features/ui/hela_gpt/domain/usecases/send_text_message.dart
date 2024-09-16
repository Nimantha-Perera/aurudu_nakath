import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Add intl package for date formatting

class SendTextMessageUseCase {
  final String apiKey;
  final String apiUrl;
  late final AudioPlayer audioPlayer;

  SendTextMessageUseCase(this.apiKey, this.apiUrl) {
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
    DateTime lastMessageTime;

    if (messageList.length >= 10) {
      // Get the time of the 10th message
      lastMessageTime = DateTime.fromMillisecondsSinceEpoch(
          sendTimes[messageList.length - 10]);
      Duration timeSinceLastMessage = now.difference(lastMessageTime);

      if (timeSinceLastMessage.inHours < 10) {
        // Calculate the next available time
        DateTime nextAvailableTime = lastMessageTime.add(Duration(hours: 10));
        String formattedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(nextAvailableTime);
        return "ඔබගේ දවසේ හෙළ GPT කතාබස් සීමාව ඉක්මවා ගොස් ඇත ඔබ නැවත කතාබස් ආරම්භ කිරීම සඳහා $formattedTime තෙක් රැඳී සිටිය යුතුය.";
      }
    }

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
