import 'dart:io';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/chat_bubble.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/message_input.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();
  bool _showPlaceholderMessage = true;

  void _hidePlaceholderMessage() {
    setState(() {
      _showPlaceholderMessage = false;
    });
  }

  Future<void> _shareChatHistory(BuildContext context) async {
    // Fetch the chat messages from the ChatViewModel
    final viewModel = context.read<ChatViewModel>();
    final messages = viewModel.messages;

    // Format chat messages into a string
    final buffer = StringBuffer();
    for (var message in messages) {
      buffer
          .writeln('${message.isMe ? 'You: ' : 'HelaGPT: '}${message.message}');
    }

    // Get the directory to save the file
    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/hela_gpt_chat.txt';

    // Write chat history to the file
    final file = File(path);
    await file.writeAsString(buffer.toString());

    // Share the file
    Share.shareXFiles([XFile(path)], text: 'Here is the chat history');
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Expanded(
                child: Text('හෙළ GPT - උපදෙස්', style: TextStyle(fontSize: 18)),
              ),
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'හෙළ GPT භාවිතා කරන ආකාරය:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '1. කුමක්ද හෙළ GPT කියන්නෙ?\nහෙළ GPT යනු විශේෂිත භාෂාවකින් (සිංහලෙන්) පදනම්ව ඇති මැෂින් ලර්නින්‍‌ග් මොඩෙලයක් වෙයි. ඔබට ඔබේ ප්‍රශ්න සහ ඉල්ලීම්, එමෙන්ම ඕනෑම තොරතුරක් මෙහි ලබා දිය හැක.\n\n'
                  '2. මෙය කෙසේ භාවිතා කළ හැකිද?\nහෙළ GPT සෘජු ලෙස කථා කිරීම, ප්‍රශ්න කිරීමට, සහ උපදෙස් ලබා ගැනීමට භාවිතා කළ හැක. ඔබට පණිවිඩයක් යවන්න, සටහන් සකස් කිරීමට, සහ විවිධ වැඩ කටයුතු කරන්න පුළුවන්.\n\n'
                  '3. මට කිසිවක් අසන්න පුළුවන්ද?\nඔව් ඔබට ඕනෑම දෙයක් මෙයින් දැනගන්න පුලුවන්. අවශ්‍යයි නම් ඔබට ගැටළු සහ ප්‍රශ්න ‍යවන්න පුලුවන්. (පෞද්ගලික තොරතුරු හැර)',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaceholderMessage(VoidCallback onClose) {
    return Container(
      color: Colors.yellow[100],
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Icon(Icons.warning, color: Colors.orange),
          SizedBox(width: 20),
          Expanded(
            child: Text(
              'අවවාදයයි: කරුණාකර මෙම කතාබස් තුළ පුද්ගලික හෝ සංවේදී තොරතුරු බෙදා නොගන්න.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.black54),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("App Widget: $context");
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        context.read<FetchManageMessagesUseCase>(),
        context.read<SendTextMessageUseCase>(),
        context.read<SendImageMessageUseCase>(),
        context.read<ClearChatHistoryUseCase>(),
      )..fetchMessages(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('හෙළ GPT',
              style: TextStyle(color: Colors.white, fontSize: 18)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outlined),
              onPressed: () => _showHelpDialog(context),
            ),
          ],
          backgroundColor: AppBarTheme.of(context).backgroundColor,
        ),
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            String lastMessageDate = '';
            bool isChatEmpty = viewModel.messages.isEmpty;

            return Stack(
              children: [
                Column(
                  children: [
                    if (_showPlaceholderMessage)
                      _buildPlaceholderMessage(_hidePlaceholderMessage),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: viewModel.messages.length +
                            (viewModel.isTyping ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < viewModel.messages.length) {
                            var message = viewModel.messages[index];
                            String currentMessageDate =
                                DateFormat('y MMM d').format(message.timestamp);

                            bool shouldShowDate =
                                currentMessageDate != lastMessageDate;
                            lastMessageDate = currentMessageDate;

                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: message.isMe
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  if (shouldShowDate)
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              color: Color.fromARGB(
                                                  255, 175, 175, 175),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                currentMessageDate,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(
                                                      255, 255, 255, 255),
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
                                        ? Theme.of(context).colorScheme.tertiary// Light green for user
                                        : Theme.of(context).primaryColorLight, // Light orange for bot
                                    textColor: message.isMe
                                        ? Theme.of(context).canvasColor
                                        :Theme.of(context).canvasColor,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Lottie.asset(
                                  "assets/animations/typing.json",
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    MessageInput(),
                  ],
                ),
                if (!isChatEmpty)
                  Positioned(
                    
                    bottom: 76.0,
                    right: 16.0,
                    
                    child: FloatingActionButton(
                      
                      onPressed: () => _shareChatHistory(context),
                      child: Icon(
                        Icons.share,
                        size: 20,
                        color: const Color.fromARGB(255, 63, 63, 63),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
