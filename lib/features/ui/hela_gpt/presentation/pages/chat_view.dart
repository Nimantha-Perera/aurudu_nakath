import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/get_messages.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'chat_bubble.dart'; // Assuming this is your updated widget

class ChatView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        GetMessagesUseCase(),
        SendMessageUseCase(),
      )..fetchMessages(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('හෙළ GPT', style: TextStyle(color: Colors.white, fontSize: 18)),
          centerTitle: true,
          backgroundColor: Color(0xFFFABC3F),
        ),
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_scrollController.hasClients) {
                _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
              }
            });

            String lastMessageDate = '';

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: viewModel.messages.length + (viewModel.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < viewModel.messages.length) {
                        var message = viewModel.messages[index];
                        String currentMessageDate = DateFormat('y MMM d').format(message.timestamp);

                        bool shouldShowDate = currentMessageDate != lastMessageDate;
                        lastMessageDate = currentMessageDate;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              if (shouldShowDate)
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0),
                                          color: Color.fromARGB(255, 0, 169, 221),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text(
                                            currentMessageDate,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ChatBubble(
                                message: message.message,
                                isMe: message.isMe,
                                backgroundColor: message.isMe
                                    ? Color(0xFFE0FFC2) // Light green for user
                                    : Color(0xFFFFF3E0), // Light orange for bot
                                textColor: message.isMe ? Colors.black : Colors.black87,
                                borderRadius: message.isMe
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(18.0),
                                        bottomLeft: Radius.circular(18.0),
                                        bottomRight: Radius.circular(0),
                                        topRight: Radius.circular(18.0),
                                      )
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(18.0),
                                        bottomLeft: Radius.circular(0),
                                        bottomRight: Radius.circular(18.0),
                                        topRight: Radius.circular(18.0),
                                      ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Bot is typing...",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                _buildMessageInput(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context) {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<String> textNotifier = ValueNotifier<String>('');

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: (text) {
              textNotifier.value = text;
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
          valueListenable: textNotifier,
          builder: (context, text, child) {
            return CircleAvatar(
              backgroundColor: Color(0xFFFABC3F),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: text.isNotEmpty
                    ? () {
                        Provider.of<ChatViewModel>(context, listen: false)
                            .sendMessage(text);
                        controller.clear();
                        textNotifier.value = ''; // Clear the notifier as well
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
