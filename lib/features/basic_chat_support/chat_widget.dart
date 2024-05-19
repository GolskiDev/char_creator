import 'package:char_creator/features/basic_chat_support/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

class ChatWidget extends StatelessWidget {
  const ChatWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: [],
      onSendPressed: (message) {},
      user: ChatUtils.chatUser,
    );
  }
}
