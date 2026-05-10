import 'dart:math';

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
    final rng = Random();
    var result = text;

    // {{snippet:name}} → snippet content (expanded first so snippets can contain spell vars)
    for (final entry in snippets.entries) {
      result = result.replaceAll('{{snippet:${entry.key}}}', entry.value);
    }

    // {{rand:[v1, v2, v3]}} → one random value from the list
    result = result.replaceAllMapped(
      RegExp(r'\{\{rand:\[([^\]]+)\]\}\}'),
      (m) {
        final raw = m.group(1) ?? '';
        final values = raw.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
        if (values.isEmpty) return '';
        return values[rng.nextInt(values.length)];
      },
    );

    // {{rand:min-max}} → random integer in [min, max]
    result = result.replaceAllMapped(
      RegExp(r'\{\{rand:(\d+)-(\d+)\}\}'),
      (m) {
        final min = int.tryParse(m.group(1) ?? '') ?? 0;
        final max = int.tryParse(m.group(2) ?? '') ?? min;
        if (max <= min) return '$min';
        return '${min + rng.nextInt(max - min + 1)}';
      },
    );

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
