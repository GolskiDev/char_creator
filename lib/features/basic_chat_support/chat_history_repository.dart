import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_message.dart';

final myChatHistoryProvider = StreamProvider<List<MyMessage>>(
  (ref) => ref.watch(chatRepositoryProvider).stream,
);

final chatRepositoryProvider = Provider<ChatHistoryRepository>(
  (ref) => ChatHistoryRepository(),
);

class ChatHistoryRepository {
  static const String _storageKey = 'chatHistory';

  Stream<List<MyMessage>> get stream => _controller.stream;

  final StreamController<List<MyMessage>> _controller;

  ChatHistoryRepository()
      : _controller = StreamController<List<MyMessage>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeMessage(MyMessage message) {
    final Map<String, dynamic> messageMap = message.toJson();
    return json.encode(messageMap);
  }

  MyMessage _decodeMessage(String encodedMessage) {
    final Map<String, dynamic> messageMap = json.decode(encodedMessage);
    return MyMessage.fromJson(messageMap);
  }

  Future<void> saveMessage(MyMessage message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedMessage = _encodeMessage(message);
    List<String> messages = prefs.getStringList(_storageKey) ?? [];
    messages.add(encodedMessage);
    await prefs.setStringList(_storageKey, messages);

    await _refreshStream();
  }

  Future<List<MyMessage>> getAllMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encodedMessages = prefs.getStringList(_storageKey);
    if (encodedMessages == null) {
      return [];
    }
    final messages = encodedMessages
        .map((encodedMessage) => _decodeMessage(encodedMessage))
        .toList();
    return messages;
  }

  Future<void> _refreshStream() async {
    final List<MyMessage> messages = await getAllMessages();
    print('refreshing stream with ${messages.length} messages');
    _controller.add(messages);
  }
}
