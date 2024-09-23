import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

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

  final List<String> _conversationHistory = [];

  Future<String> sendTextToGemini(String userText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messageList = prefs.getStringList('messages') ?? [];
    List<int> sendTimes = _getIntList(prefs, 'sendTimes');

    DateTime now = DateTime.now();
    DateTime lastMessageTime;

    // Ensure the message history has at least 10 messages
    if (messageList.length >= 10) {
      // Get the time of the 10th most recent message
      lastMessageTime = DateTime.fromMillisecondsSinceEpoch(
          sendTimes[messageList.length - 10]);
      Duration timeSinceLastMessage = now.difference(lastMessageTime);

      // Check if the time difference is less than 5 hours
      if (timeSinceLastMessage.inHours < 5) {
        // Calculate the next available time
        DateTime nextAvailableTime = lastMessageTime.add(Duration(hours: 5));
        String formattedTime =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(nextAvailableTime);
        return "ඔබගේ දවසේ හෙළ GPT කතාබස් සීමාව ඉක්මවා ගොස් ඇත. "
               "ඔබ නැවත කතාබස් ආරම්භ කිරීම සඳහා $formattedTime තෙක් රැඳී සිටිය යුතුය.";
      }
    }

    // Remove the oldest message if the list exceeds 20 messages
    if (messageList.length >= 10) {
      messageList.removeAt(0);
      sendTimes.removeAt(0);
    }

    // Add the new message and its timestamp
    messageList.add(userText);
    sendTimes.add(now.millisecondsSinceEpoch);

    // Save the updated message list and send times to SharedPreferences
    await prefs.setStringList('messages', messageList);
    await _setIntList(prefs, 'sendTimes', sendTimes);

    // Add the user text to the conversation history
    _conversationHistory.add('User: $userText');

    // Construct the prompt from the conversation history
    final prompt = _conversationHistory.join('\n');

    // Send the conversation history to Gemini for a response
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    try {
      final response = await model.generateContent([
        Content.multi([TextPart(prompt)]),
      ]);

      if (response != null) {
        await playMessageSentSound();
        final geminiResponse = response.text ?? 'No response text available';

        // Add Gemini's response to the conversation history
        _conversationHistory.add('හෙළ GPT: $geminiResponse');

        print('Gemini response: $geminiResponse');
        return geminiResponse;
      } else {
        return "No valid response from API";
      }
    } catch (e) {
      return "Failed to process text: $e";
    }
  }

  Future<void> clearConversationHistory() async {
    _conversationHistory.clear();
  }

  List<int> _getIntList(SharedPreferences prefs, String key) {
    final jsonString = prefs.getString(key);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<int>();
  }

  Future<void> _setIntList(SharedPreferences prefs, String key, List<int> list) async {
    final jsonString = jsonEncode(list);
    await prefs.setString(key, jsonString);
  }
}
