import 'dart:convert';

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

  MyMessage({
    required this.text,
    required this.author,
    this.fields,
  });

  factory MyMessage.fromJson(Map<String, dynamic> json) {
    return MyMessage(
      text: json['text'],
      author: MyMessageType.fromJson(
        json['author'],
      ),
      fields: jsonDecode(json['fields'])?.cast<Map<String, dynamic>>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author.toJson(),
      'fields': jsonEncode(fields),
    };
  }
}
