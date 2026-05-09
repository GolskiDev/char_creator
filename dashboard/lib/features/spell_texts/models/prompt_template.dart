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

  /// Returns the prompt with snippet and spell-specific placeholders substituted.
  ///
  /// [snippets] maps snippet names to their content. Snippet references
  /// (`{{snippet:name}}`) are expanded first so snippet content can itself
  /// contain `{{title}}` / `{{description}}` / `{{id}}` placeholders.
  /// Unknown snippet references are left as-is.
  String resolve(Spell spell, {Map<String, String> snippets = const {}}) {
    var result = text;
    for (final entry in snippets.entries) {
      result = result.replaceAll('{{snippet:${entry.key}}}', entry.value);
    }
    return result
        .replaceAll('{{title}}', spell.title)
        .replaceAll('{{description}}', spell.description)
        .replaceAll('{{id}}', spell.id);
  }

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
