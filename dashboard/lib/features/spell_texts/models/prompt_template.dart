import 'spell.dart';

class PromptTemplate {
  final String id;

  /// The template text. Supports {{title}}, {{description}}, {{id}} placeholders.
  final String text;

  final DateTime createdAt;

  const PromptTemplate({
    required this.id,
    required this.text,
    required this.createdAt,
  });

  /// Returns the prompt with spell-specific placeholders substituted.
  String resolve(Spell spell) => text
      .replaceAll('{{title}}', spell.title)
      .replaceAll('{{description}}', spell.description)
      .replaceAll('{{id}}', spell.id);

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PromptTemplate.fromJson(Map<String, dynamic> json) => PromptTemplate(
        id: json['id'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  /// The first line of the template text, used for display in history lists.
  String get preview {
    final firstLine = text.split('\n').first.trim();
    return firstLine.length > 60 ? '${firstLine.substring(0, 59)}…' : firstLine;
  }
}
