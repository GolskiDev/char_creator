import 'spell_text_status.dart';

class SpellTextResult {
  final String id;
  final String spellId;
  final String spellTitle;
  final String spellDescription;
  final String generatedText;
  final DateTime createdAt;
  SpellTextStatus status;

  /// Extra fields returned by the LLM when JSON output is used
  /// (e.g. `{"text": "...", "tone": "dark", "intensity": 8}`).
  /// Null when the LLM returned plain text.
  final Map<String, dynamic>? metadata;

  /// LLM temperature used when this result was generated (0.0–1.0).
  /// Null for imported results or results generated before this field was added.
  final double? temperature;

  SpellTextResult({
    required this.id,
    required this.spellId,
    required this.spellTitle,
    required this.spellDescription,
    required this.generatedText,
    required this.createdAt,
    this.status = SpellTextStatus.pending,
    this.metadata,
    this.temperature,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'spellId': spellId,
        'spellTitle': spellTitle,
        'spellDescription': spellDescription,
        'generatedText': generatedText,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
        if (metadata?.isNotEmpty == true) 'metadata': metadata,
        if (temperature != null) 'temperature': temperature,
      };

  factory SpellTextResult.fromJson(Map<String, dynamic> json) =>
      SpellTextResult(
        id: json['id'] as String,
        spellId: (json['spellId'] as String?) ?? '',
        spellTitle: json['spellTitle'] as String,
        spellDescription: json['spellDescription'] as String,
        generatedText: json['generatedText'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: SpellTextStatus.values.byName(json['status'] as String),
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : null,
        temperature: (json['temperature'] as num?)?.toDouble(),
      );
}
