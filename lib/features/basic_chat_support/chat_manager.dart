import 'dart:async';

import 'lc.dart';

sealed class ChatSender {}

class User extends ChatSender {}

class Bot extends ChatSender {}

class System extends ChatSender {}

class ChatMessage {
  final String message;
  final ChatSender sender;
  final DateTime timestamp;

  ChatMessage(this.message, this.sender, this.timestamp);
}

class ChatManager {
  final LC _lc = LC();
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>();
  List<ChatMessage> _currentMessages = [];

  final User user = User();
  final Bot bot = Bot();

  Stream<List<ChatMessage>> messagesStream() {
    return _messagesController.stream;
  }

  addMessage(ChatMessage message) {
    _currentMessages.add(message);
    _messagesController.add(_currentMessages);
  }

  addUserMessage(String message) {
    final chatMessage = ChatMessage(
      message,
      user,
      DateTime.now(),
    );
    addMessage(chatMessage);
    _lc.promptChat(message).then((response) {
      addBotMessage(response);
    });
  }

  addBotMessage(String message) {
    final chatMessage = ChatMessage(
      message,
      bot,
      DateTime.now(),
    );
    addMessage(chatMessage);
  }
}
