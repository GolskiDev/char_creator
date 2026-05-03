import 'spell_text_status.dart';

class SpellTextResult {
  final String id;
  final String spellId;
  final String spellTitle;
  final String spellDescription;
  final String generatedText;
  final DateTime createdAt;
  SpellTextStatus status;

  SpellTextResult({
    required this.id,
    required this.spellId,
    required this.spellTitle,
    required this.spellDescription,
    required this.generatedText,
    required this.createdAt,
    this.status = SpellTextStatus.pending,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'spellId': spellId,
        'spellTitle': spellTitle,
        'spellDescription': spellDescription,
        'generatedText': generatedText,
        'createdAt': createdAt.toIso8601String(),
        'status': status.name,
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
      );
}
