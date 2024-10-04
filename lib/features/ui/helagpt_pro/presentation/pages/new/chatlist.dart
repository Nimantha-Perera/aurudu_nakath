import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/bloc/chat_view_model.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ChatList extends StatefulWidget {
  final ChatViewModel viewModel;

  ChatList({required this.viewModel});

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ScrollController _scrollController = ScrollController();
  bool _shouldAutoScroll = true;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_handleNewMessage);
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_handleNewMessage);
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.hasClients) {
      double maxScroll = _scrollController.position.maxScrollExtent;
      double currentScroll = _scrollController.position.pixels;
      double delta = 50.0; // Threshold to consider user is near bottom
      _shouldAutoScroll = (maxScroll - currentScroll) <= delta;
    }
  }

  void _handleNewMessage() {
    if (_shouldAutoScroll) {
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String lastMessageDate = '';

    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.viewModel.messages.length + (widget.viewModel.isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < widget.viewModel.messages.length) {
          var message = widget.viewModel.messages[index];
          String currentMessageDate = DateFormat('y MMM d').format(message.timestamp);

          bool shouldShowDate = currentMessageDate != lastMessageDate;
          lastMessageDate = currentMessageDate;

          return Column(
            crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
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
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).primaryColorLight,
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
                   imagePath: message.imagePath,     
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