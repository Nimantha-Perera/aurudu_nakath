import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/clear_chat.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/fetch_and%20_manegemessage.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_img.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/domain/usecases/send_text_message.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/message_input.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/chatlist.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/help_dialog.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/placeholder.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/share_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';


class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  bool _showPlaceholderMessage = true;

  void _hidePlaceholderMessage() {
    setState(() {
      _showPlaceholderMessage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        context.read<FetchManageMessagesUseCase>(),
        context.read<SendTextMessageUseCase>(),
        context.read<SendImageMessageUseCase>(),
        context.read<ClearChatHistoryUseCase>(),
      )..fetchMessages(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('හෙළ GPT', style: TextStyle(color: Colors.white, fontSize: 18)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.help_outlined),
              onPressed: () => showHelpDialog(context),
            ),
          ],
        ),
        body: Consumer<ChatViewModel>(
          builder: (context, viewModel, child) {
            bool isChatEmpty = viewModel.messages.isEmpty;

            return Stack(
              children: [
                Column(
                  children: [
                    if (_showPlaceholderMessage)
                      PlaceholderMessage(onClose: _hidePlaceholderMessage),
                    Expanded(
                      child: ChatList(viewModel: viewModel),
                    ),
                    MessageInput(),
                  ],
                ),
                if (!isChatEmpty)
                  Positioned(
                    bottom: 76.0,
                    right: 16.0,
                    child: ShareButton(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
