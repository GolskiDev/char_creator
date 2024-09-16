import 'dart:html';

import 'package:char_creator/features/basic_chat_support/chat_bot.dart';
import 'package:char_creator/features/basic_chat_support/chat_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as chatTypes;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:langchain/langchain.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  List<chatTypes.Message> messages = [];
  final ChatBot chatBot = ChatBotWithMemory(
    ConversationBufferMemory(returnMessages: true),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    document.onContextMenu.listen((event) => event.preventDefault());
  }

  @override
  Widget build(BuildContext context) {
    return Chat(
      messages: messages,
      onSendPressed: _onSendPressed,
      user: ChatUtils.chatUser,
      textMessageBuilder: (p0, {required messageWidth, required showName}) {
        return Container(
          padding: EdgeInsets.all(8),
          child: SelectableText(
            p0.text,
            contextMenuBuilder: (context, editableTextState) {
              return ListView(
                children: [
                  ListTile(
                    title: Text('Copy'),
                    onTap: () {
                      // editableTextState?.copy();
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Translate'),
                    onTap: () async {
                      // final response = await chatBot.extractJson(p0.text);
                      // final translation = jsonDecode(response)['translation'];
                      // editableTextState?.insertText(translation);
                      // Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          )
        );
      },
      onMessageLongPress: (context, p1) async {
        if (p1.author.id == ChatUtils.chatUser.id) {
          return;
        }
        final message = p1 as chatTypes.TextMessage;
        final prompt = message.text;
        final response = await chatBot.extractJson(prompt);
      },
    );
  }

  void _onSendPressed(chatTypes.PartialText message) async {
    final newMessage = chatTypes.TextMessage(
      author: ChatUtils.chatUser,
      id: messages.length.toString(),
      text: message.text,
    );
    setState(() {
      messages.insert(0, newMessage);
    });
    final response = await chatBot.sendUserMessage(message.text);
    final botMessage = chatTypes.TextMessage(
      author: ChatUtils.botUser,
      id: messages.length.toString(),
      text: response,
    );
    setState(() {
      messages.insert(0, botMessage);
    });
  }
}
