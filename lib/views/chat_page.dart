import 'package:char_creator/features/chat_context/chat_context_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/basic_chat_support/my_chat_widget.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({this.documentId, super.key});
  final String? documentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      endDrawer: Drawer(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ChatContextWidget(
              currentDocumentId: documentId,
            ),
          ),
        ),
      ),
      body: MyChatWidget(
        documentId: documentId,
      ),
    );
  }
}
