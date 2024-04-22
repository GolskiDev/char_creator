import 'dart:math';

import 'package:char_creator/features/basic_chat_support/chat_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final chatManager = ChatManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<List<ChatMessage>>(
            stream: chatManager.messagesStream(),
            builder: (context, snapshot) {
              final messages = snapshot.data?.reversed.map(
                    (chatMessage) => types.TextMessage(
                      author: switch (chatMessage.sender) {
                        User() => types.User(id: '1'),
                        Bot() => types.User(id: '2'),
                        System() => types.User(id: '3'),
                      },
                      id: Random().nextInt(10000).toString(),
                      text: chatMessage.message,
                    ),
                  ) ??
                  [];
              return Chat(
                messages: messages.toList(),
                onSendPressed: _handleSendPressed,
                user: types.User(id: '1'),
              );
            }),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    print('Message sent: ${message.text}');
    chatManager.addUserMessage(message.text);
  }
}
