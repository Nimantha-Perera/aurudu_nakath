import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';

class SendGeneratedImageMessageUseCase2 {
  final String apiKey;

  SendGeneratedImageMessageUseCase2(this.apiKey);

  /// Generates an image from a given Sinhala text prompt by translating it to English
  /// and then calling the API to generate the image.
  /// [text] is the prompt in Sinhala that will be used to generate the image.
  /// Returns the File of the generated image.
  Future<File> generateImageFromText(String text) async {
    try {
      final translator = GoogleTranslator();

      // Define keywords to block
      final blockedKeywords = [
        'sexy', 'nudity', 'nude', 'child',
        'කාමුක', 'නිරුවත්', 'හෙලුවෙන්',"අසභ්‍ය","porn"
      ];

      // Check if the input text contains any blocked keywords
      for (final keyword in blockedKeywords) {
        if (text.toLowerCase().contains(keyword)) {
          throw Exception('ආදාන පෙළෙහි තහනම් මූල පද අඩංගු වේ.');
        }
      }

      // Define keywords to remove
      final generateKeywords = ['generate', 'අඳින්න', 'උත්පාදනය කරන්න', 'ජායාරූපය'];

      // Remove keywords from the input text
      for (final keyword in generateKeywords) {
        text = text.replaceAll(keyword, '');
      }

      // Trim whitespace
      text = text.trim();

      // Translate Sinhala text to English
      final translatedText = await translator.translate(text, from: 'si', to: 'en');

      final apiUrl = "https://api-inference.huggingface.co/models/ZB-Tech/Text-to-Image";
      final hugapiKey = dotenv.env['HUG_FACE_API'] ?? "";

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $hugapiKey',
        },
        body: jsonEncode({
          'inputs': translatedText.text,
        }),
      );

      if (response.statusCode == 200) {
        // The response is expected to be binary image data
        Uint8List bytes = response.bodyBytes;

        // Create a file to save the image
        final Directory directory = await Directory.systemTemp.createTemp();
        final File file = File('${directory.path}/generated_image.png');

        // Write the bytes to the file
        await file.writeAsBytes(bytes);

        return file; // Return the saved file
      } else {
        throw Exception('Failed to generate image. Error: ${response.body}');
      }
    } catch (error) {
      print('An error occurred: $error');
      rethrow; // Rethrow if you want to propagate the error to the caller
    }
  }
}
