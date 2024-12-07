import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/basic_chat_support/my_chat_widget.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({this.documentId, super.key});
  final String? documentId;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: MyChatWidget(
        documentId: documentId,
      ),
    );
  }
}
