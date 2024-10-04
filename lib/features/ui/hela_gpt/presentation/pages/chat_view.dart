import 'package:aurudu_nakath/features/ui/Review/review_provider.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/message_input.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/chatlist.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/drawer_route.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/full_screen_drower.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/help_dialog.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/placeholder.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/share_btn.dart';
import 'package:aurudu_nakath/features/ui/hela_gpt/presentation/pages/new/side_nav/helagpt_sidenav..dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  void initState() {
    super.initState();
    Provider.of<ReviewProvider>(context, listen: false).requestReview();
  }

  void _openFullScreenDrawer() {
    Navigator.of(context).push(
      FullScreenDrawerPageRoute(
        page: FullScreenDrawer(
          onClose: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var icon = Icon(FontAwesomeIcons.bars, size: 18);
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
      )..fetchMessages(),
      child: Scaffold(
        drawer: HelagptDrawer(),
        appBar: AppBar(
          title: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 3,
            ),
            onPressed: _openFullScreenDrawer,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Get හෙළ GPT PRO',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                SizedBox(width: 8),
                Icon(FontAwesomeIcons.bolt, size: 18),
              ],
            ),
          ),
          centerTitle: true,
          leading: Builder(
            builder: (context) => IconButton(
              icon: icon,
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.help_outlined),
              onPressed: () => showHelpDialog(context),
            ),
          ],
        ),
        body: SafeArea(
          child: Consumer<ChatViewModel>(
            builder: (context, viewModel, child) {
              bool isChatEmpty = viewModel.messages.isEmpty;

              return Stack(
                children: [
                  Column(
                    children: [
                      if (_showPlaceholderMessage)
                        PlaceholderMessage(onClose: _hidePlaceholderMessage),
                      Expanded(
                        child: isChatEmpty && !_showPlaceholderMessage
                            ? Center(
                                child: Text(
                                  'හෙළ සහකරු',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              )
                            : ChatList(viewModel: viewModel),
                      ),
                      MessageInput(),
                    ],
                  ),
                  if (!isChatEmpty)
                    Positioned(
                      
                      bottom: 100.0,
                      right: 16.0,
                      child: ShareButton(),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}