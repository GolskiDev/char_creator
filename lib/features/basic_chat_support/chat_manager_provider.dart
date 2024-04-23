import 'package:flutter/widgets.dart';
import 'package:char_creator/features/basic_chat_support/chat_manager.dart';

class ChatManagerProvider extends InheritedWidget {
  final ChatManager chatManager;

  ChatManagerProvider({
    Key? key,
    required this.chatManager,
    required Widget child,
  }) : super(key: key, child: child);

  static ChatManagerProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatManagerProvider>();
  }

  @override
  bool updateShouldNotify(ChatManagerProvider oldWidget) {
    return chatManager != oldWidget.chatManager;
  }
}
