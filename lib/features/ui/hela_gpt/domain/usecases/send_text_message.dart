import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

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
}
