// add required imports
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import 'chat_manager.dart';
import 'chat_manager_provider.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.messagesStream,
  });
  final Stream<List<ChatMessage>> messagesStream;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget>
    with AutomaticKeepAliveClientMixin<ChatWidget> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StreamBuilder<List<ChatMessage>>(
      stream: widget.messagesStream,
      builder: (context, snapshot) {
        final messages = snapshot.data?.reversed
                .map(
                  (chatMessage) => types.TextMessage(
                    author: _getAuthor(chatMessage.sender),
                    id: Random().nextInt(10000).toString(),
                    text: chatMessage.message,
                  ),
                )
                .toList() ??
            [];
        return Chat(
          messages: messages,
          onSendPressed: (message) => _handleSendPressed(context, message),
          user: types.User(id: '1'),
        );
      },
    );
  }

  types.User _getAuthor(ChatSender sender) {
    switch (sender) {
      case User():
        return types.User(id: '1');
      case Bot():
        return types.User(id: '2');
      case System():
        return types.User(id: '3');
    }
  }

  void _handleSendPressed(BuildContext context, types.PartialText message) {
    print('Message sent: ${message.text}');
    ChatManagerProvider.of(context)?.chatManager.addUserMessage(message.text);
  }

  @override
  bool get wantKeepAlive => true;
}