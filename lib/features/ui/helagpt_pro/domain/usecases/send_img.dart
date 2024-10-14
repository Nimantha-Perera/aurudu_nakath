import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:image_picker/image_picker.dart';

class SendImageMessageUseCase2 {
  final String apiKey;

  SendImageMessageUseCase2(this.apiKey);

  Future<String> sendImageWithText(XFile image, String text) async {
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final prompt = TextPart(text);
    final imageBytes = await image.readAsBytes();
    final imagePart = DataPart('image/jpeg', imageBytes);

    try {
      final response = await model.generateContent([
        Content.multi([prompt, imagePart]),
      ]);

      if (response != null) {
        return response.text ?? 'No response text available';
      } else {
        return "No valid response from API";
      }
    } catch (e) {
      return "Failed to process image: $e";
    }
  }
}