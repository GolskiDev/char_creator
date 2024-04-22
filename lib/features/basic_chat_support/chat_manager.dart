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
  final StreamController<List<String>> _messagesController = StreamController<List<String>>();
  List<String> _currentMessages = [];

  Stream<List<String>> messagesStream() {
    return _messagesController.stream;  
  }

  addMessage(String message){
    _currentMessages.add(message);
    _messagesController.add(_currentMessages);
  }

  submitUserMessage(String message) {
    addMessage(message);
    _lc.promptChat(message).then((response) {
      addMessage(response);
    });
  }
}
