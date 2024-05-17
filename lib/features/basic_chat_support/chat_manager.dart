import 'dart:async';

import '../uncategorized_use_cases.dart';
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

  addSystemMessage(String message) {
    _promptChat(message).then((response) {
      addBotMessage(response);
    });
  }

  addMessage(ChatMessage message) {
    _currentMessages.add(message);
    _messagesController.add(_currentMessages);
  }

  addUserMessage(String message) async {
    final chatMessage = ChatMessage(
      message,
      user,
      DateTime.now(),
    );
    addMessage(chatMessage);
    final response = await _lc.askChatForJsonWithInstructions(message);
     final responseMessage = response['messege'];
      if (responseMessage != null) {
        addBotMessage(responseMessage);
      }
      final trait = response['trait'];
      UncategorizedUseCases().updateCharacterBasedOnResponse(
        responseMessage,
        'name',
      );
  }

  addBotMessage(String message) {
    final chatMessage = ChatMessage(
      message,
      bot,
      DateTime.now(),
    );
    addMessage(chatMessage);
  }

  Future<String> _promptChat(String message) {
    return _lc.promptChat(message);
  }
}
