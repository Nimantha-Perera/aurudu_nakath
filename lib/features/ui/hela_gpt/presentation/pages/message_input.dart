import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:image_picker/image_picker.dart';

class MessageInput extends StatefulWidget {
  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final ValueNotifier<String> _textNotifier = ValueNotifier<String>('');
  final ImagePicker _picker = ImagePicker();

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
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final text = _textNotifier.value; // Get current text from input
      Provider.of<ChatViewModel>(context, listen: false)
          .sendImage(image, text);
      _controller.clear();
      _textNotifier.value = ''; // Clear the notifier as well
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
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
                  onPressed: text.isNotEmpty
                      ? () {
                          Provider.of<ChatViewModel>(context, listen: false)
                              .sendMessage(text);
                          _controller.clear();
                          _textNotifier.value = ''; // Clear the notifier as well
                        }
                      : null, // Disable the button if text is empty
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
