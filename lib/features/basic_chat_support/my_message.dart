import 'dart:convert';

import '../fields/field_values/field_value.dart';

enum MyMessageType {
  human,
  bot;

  String toJson() {
    switch (this) {
      case MyMessageType.human:
        return 'human';
      case MyMessageType.bot:
        return 'bot';
    }
  }

  static MyMessageType fromJson(String json) {
    switch (json) {
      case 'human':
        return MyMessageType.human;
      case 'bot':
        return MyMessageType.bot;
    }
    throw ArgumentError('Invalid json value');
  }
}

class MyMessage {
  final String text;
  final MyMessageType author;
  final List<Map<String, dynamic>>? fields;
  final String? imageId;

  MyMessage({
    required this.text,
    required this.author,
    this.fields,
    this.imageId,
  });

  factory MyMessage.fromJson(Map<String, dynamic> json) {
    return MyMessage(
      text: json['text'],
      author: MyMessageType.fromJson(
        json['author'],
      ),
      fields: jsonDecode(json['fields'])?.cast<Map<String, dynamic>>(),
      imageId: json['imageId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author.toJson(),
      'fields': jsonEncode(fields),
      'imageId': imageId,
    };
  }
}
