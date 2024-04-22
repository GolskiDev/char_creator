import 'package:char_creator/features/basic_chat_support/lc.dart';
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
    return MaterialApp(
      home: LCBuilder(
        builder: (context, lc) => const Scaffold(
          body: Chat(
            messages: [],
            onSendPressed: _handleSendPressed,
            user: types.User(id: '1'),
          ),
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    print('Message sent: ${message.text}');
  }
}

class LCBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, LC lc) builder;
  const LCBuilder({super.key, required this.builder});

  @override
  State<LCBuilder> createState() => _LCBuilderState();
}

class _LCBuilderState extends State<LCBuilder> {
  final LC _lc = LC();
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _lc);
  }
}
