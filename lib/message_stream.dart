import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

void main() {
  List<String> messages = [];

  List<String> newMessages = List.from(messages);
}

Stream<List<types.Message>> getMessagesStream() {
  final Stream messsage = Stream<types.TextMessage>.value(
    types.TextMessage(
      id: '1',
      text: 'Hello World',
      author: types.User(id: '2'),
    ),
  );
}
