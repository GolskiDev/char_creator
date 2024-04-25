import 'package:char_creator/features/basic_chat_support/chat_manager.dart';
import 'package:char_creator/features/basic_chat_support/chat_manager_provider.dart';
import 'package:char_creator/features/styling/list_of_all_widgets.dart';
import 'package:flutter/material.dart';

import 'features/basic_chat_support/chat_widget.dart';
import 'features/prompt_list/prompt_list_widget.dart';
import 'features/prompt_list/prompt_model.dart';

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
      theme: ThemeData.dark(),
      home: Scaffold(
        body: ChatManagerProvider(
          chatManager: ChatManager(),
          child: const ListOfAllWidgets(),
        ),
      ),
    );
  }
}

class PageViewWidget extends StatefulWidget {
  const PageViewWidget({super.key});

  @override
  State<PageViewWidget> createState() => _PageViewWidgetState();
}

class _PageViewWidgetState extends State<PageViewWidget> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final chatManager = ChatManagerProvider.of(context)?.chatManager;
    return PageView(
      controller: _pageController,
      children: [
        PromptListWidget(
          onPromptSelected: chatManager != null
              ? (prompt) => _onPromptSelected(chatManager, prompt)
              : null,
        ),
        ChatWidget(
          messagesStream: chatManager?.messagesStream() ?? const Stream.empty(),
        ),
      ],
    );
  }

  _onPromptSelected(ChatManager chatManager, PromptModel promptModel) {
    chatManager.addSystemMessage(promptModel.prompt);
    goToChat();
  }

  goToChat() {
    _pageController.animateToPage(
      1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
