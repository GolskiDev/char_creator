class DailyText {
  final String id;
  final String spellId;
  final String subtitle;

  DailyText({required this.id, required this.spellId, required this.subtitle});

  factory DailyText.fromJson(Map<String, dynamic> json) {
    return DailyText(
      id: json['id'] as String,
      spellId: json['spellId'] as String,
      subtitle: json['subtitle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'spellId': spellId, 'subtitle': subtitle};
  }

  DailyText copyWith({String? id, String? spellId, String? subtitle}) {
    return DailyText(
      id: id ?? this.id,
      spellId: spellId ?? this.spellId,
      subtitle: subtitle ?? this.subtitle,
    );
  }
}
