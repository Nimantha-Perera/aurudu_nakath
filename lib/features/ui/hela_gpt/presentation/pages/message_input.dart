import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  final ImagePicker _picker = ImagePicker();
  
  XFile? _selectedImage; // Store the selected image

  @override
  void dispose() {
    _controller.dispose();
    _textNotifier.dispose();
    super.dispose();
  }

  void _startNewChat() {
    final chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    chatViewModel.clearChat(); // Clear old messages
    _controller.clear();
    _textNotifier.value = ''; // Clear the text field
    _selectedImage = null; // Clear the selected image
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image; // Store the selected image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the selected image if available
          if (_selectedImage != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8.0),
              constraints: BoxConstraints(
                maxHeight: 150, // Adjust max height as needed
                maxWidth: double.infinity,
              ),
              child: Image.file(
                File(_selectedImage!.path),
                fit: BoxFit.cover, // Adjust fit as needed
              ),
            ),
          Row(
            children: [
              // Button to start a new chat
              IconButton(
                icon: Icon(Icons.add, color: Colors.blue),
                onPressed: _startNewChat,
              ),
              SizedBox(width: 10),
              // Button to pick an image
              IconButton(
                icon: Icon(Icons.image, color: Colors.blue),
                onPressed: _pickImage,
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: (text) {
                    _textNotifier.value = text;
                  },
                  decoration: InputDecoration(
                    hintText: 'අවශ්‍ය දේ මෙහි ලියන්න...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              ValueListenableBuilder<String>(
                valueListenable: _textNotifier,
                builder: (context, text, child) {
                  return CircleAvatar(
                    backgroundColor: Color(0xFFFABC3F),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: (text.isNotEmpty || _selectedImage != null)
                          ? () {
                              if (_selectedImage != null) {
                                // Send both image and text
                                Provider.of<ChatViewModel>(context, listen: false)
                                    .sendImage(_selectedImage!, text);
                                setState(() {
                                  _selectedImage = null; // Clear the selected image after sending
                                });
                              } else {
                                // Send only text
                                Provider.of<ChatViewModel>(context, listen: false)
                                    .sendMessage(text);
                              }
                              _controller.clear();
                              _textNotifier.value = ''; // Clear the notifier as well
                            }
                          : null, // Disable the button if text is empty and no image is selected
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
