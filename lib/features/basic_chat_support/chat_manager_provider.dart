import 'package:flutter/widgets.dart';
import 'package:char_creator/features/basic_chat_support/chat_manager.dart';

class ChatManagerProvider extends InheritedWidget {
  final ChatManager chatManager;

  const ChatManagerProvider({
    super.key,
    required this.chatManager,
    required super.child,
  });

  static ChatManagerProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatManagerProvider>();
  }

  @override
  bool updateShouldNotify(ChatManagerProvider oldWidget) {
    return chatManager != oldWidget.chatManager;
  }
}
