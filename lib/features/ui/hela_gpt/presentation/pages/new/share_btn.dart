import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';

class ShareButton extends StatelessWidget {
  Future<void> _shareChatHistory(BuildContext context) async {
    final viewModel = context.read<ChatViewModel>();
    final messages = viewModel.messages;

    final buffer = StringBuffer();
    for (var message in messages) {
      buffer.writeln('${message.isMe ? 'You: ' : 'HelaGPT: '}${message.message}');
    }

    final directory = await getTemporaryDirectory();
    final path = '${directory.path}/hela_gpt_chat.txt';
    final file = File(path);
    await file.writeAsString(buffer.toString());

    Share.shareXFiles([XFile(path)], text: 'Here is the chat history');
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: () => _shareChatHistory(context),
      child: Icon(
        Icons.share,
        size: 20,
        color: const Color.fromARGB(255, 63, 63, 63),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
    );
  }
}
