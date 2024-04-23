import 'package:char_creator/features/basic_chat_support/chat_manager.dart';
import 'package:char_creator/features/basic_chat_support/chat_manager_provider.dart';
import 'package:flutter/material.dart';

import 'features/basic_chat_support/chat_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChatManagerProvider(
          chatManager: ChatManager(),
          child: const ChatWidget(),
        ),
      ),
    );
  }
}
