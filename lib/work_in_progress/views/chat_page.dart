import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/basic_chat_support/chat_widget.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedText = useState<String?>(null);

    return Scaffold(
      appBar: AppBar(
        title: Text(selectedText.value ?? "Chat"),
      ),
      body: Center(
        child: ChatWidget(onSelectionChanged: (text) {
          selectedText.value = text;
        }),
      ),
    );
  }
}
