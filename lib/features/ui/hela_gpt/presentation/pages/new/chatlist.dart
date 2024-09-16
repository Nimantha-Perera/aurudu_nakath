import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/bloc/chat_view_model.dart';

import 'package:lottie/lottie.dart';

class ChatList extends StatelessWidget {
  final ChatViewModel viewModel;
  final ScrollController _scrollController = ScrollController();

  ChatList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    String lastMessageDate = '';

    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.messages.length + (viewModel.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < viewModel.messages.length) {
          var message = viewModel.messages[index];
          String currentMessageDate =
              DateFormat('y MMM d').format(message.timestamp);

          bool shouldShowDate = currentMessageDate != lastMessageDate;
          lastMessageDate = currentMessageDate;

          return Column(
            crossAxisAlignment: message.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              if (shouldShowDate)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: DateLabel(currentMessageDate: currentMessageDate),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ChatBubble(
                  message: message.message,
                  isMe: message.isMe,
                  backgroundColor: message.isMe
                      ? Theme.of(context)
                          .colorScheme
                          .tertiary // Light green for user
                      : Theme.of(context)
                          .primaryColorLight, // Light orange for bot
                  textColor: message.isMe
                      ? Theme.of(context).canvasColor
                      : Theme.of(context).canvasColor,
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
              ),
            ],
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
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
    );
  }
}

class DateLabel extends StatelessWidget {
  final String currentMessageDate;

  const DateLabel({required this.currentMessageDate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Color.fromARGB(255, 175, 175, 175),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            currentMessageDate,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
