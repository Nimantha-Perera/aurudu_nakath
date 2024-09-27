import 'package:firebase_storage/firebase_storage.dart';

class LoadAppBarImageUseCase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<String> loadAppBarImage() async {
    try {
      // Try fetching the image as a .jpg
      String imageUrl = await _firebaseStorage
          .ref('appbar_images/appbar_cover.jpg')
          .getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error loading .jpg image: $e');
      try {
        // If .jpg fails, try fetching the image as a .png
        String imageUrl = await _firebaseStorage
            .ref('appbar_images/appbar_cover.png')
            .getDownloadURL();
        return imageUrl;
      } catch (e) {
        print('Error loading .png image: $e');
        return ''; // Return empty string if both attempts fail
      }
    }
  }
}
