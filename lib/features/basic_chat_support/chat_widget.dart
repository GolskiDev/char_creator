import 'package:char_creator/features/basic_chat_support/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<chatTypes.Message> messages = [];

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: messages,
      onSendPressed: _onSendPressed,
      user: ChatUtils.chatUser,
    );
  }

  void _onSendPressed(chatTypes.PartialText message) {
    final newMessage = chatTypes.TextMessage(
      author: ChatUtils.chatUser,
      id: messages.length.toString(),
      text: message.text,
    );
    setState(() {
      messages.insert(0, newMessage);
    });
  }
}
