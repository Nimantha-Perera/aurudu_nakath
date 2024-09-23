import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/bloc/chat_view_model.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/message_input.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/chatlist.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/drawer_route.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/full_screen_drower.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/help_dialog.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/message_input.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/placeholder.dart';
import 'package:aurudu_nakath/features/ui/helagpt_pro/presentation/pages/new/share_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelaGPT_PRO extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<HelaGPT_PRO> {
  bool _showPlaceholderMessage = true;

  void _hidePlaceholderMessage() {
    setState(() {
      _showPlaceholderMessage = false;
    });
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
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        context.read(),
        context.read(),
        context.read(),
        context.read(),
      )..fetchMessages(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'හෙළ GPT Pro',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white, // Set the title color to white for contrast
            ),
          ),
          centerTitle: true, // Center the title
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor, // Set a vibrant background color
          elevation: 4.0, // Add a slight shadow for depth
          actions: [
            IconButton(
              icon: Icon(
                Icons.help_outlined,
                color: Colors.white, // Change the icon color to match the theme
                size: 28, // Slightly increase the icon size
              ),
              onPressed: () => showHelpDialog(context),
              tooltip: 'උදව්', // Add a tooltip in Sinhala for better UX
            ),
          ],
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white, // Icon color
              size: 28, // Increase the size of the leading menu icon
            ),
            onPressed: () {
              // Add functionality for opening a drawer or navigation
            },
            tooltip: 'මෙනු', // Tooltip for menu button in Sinhala
          ),
         
        ),
        body: SafeArea(
          // SafeArea added here
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
      ),
    );
  }
}
