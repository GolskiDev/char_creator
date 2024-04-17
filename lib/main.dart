import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<types.Message> _messages = [];
    final _user = const types.User(id: 'abcdef');
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Chat(
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user,
          ),
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    print('Message sent: ${message.text}');
  }
}
