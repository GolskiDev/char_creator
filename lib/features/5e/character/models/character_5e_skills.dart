class Character5eSkills {
  final int? athletics;
  final int? acrobatics;
  final int? sleightOfHand;
  final int? stealth;
  final int? arcana;
  final int? history;
  final int? investigation;
  final int? nature;
  final int? religion;
  final int? animalHandling;
  final int? insight;
  final int? medicine;
  final int? perception;
  final int? survival;
  final int? deception;
  final int? intimidation;
  final int? performance;
  final int? persuasion;

  Character5eSkills({
    required this.athletics,
    required this.acrobatics,
    required this.sleightOfHand,
    required this.stealth,
    required this.arcana,
    required this.history,
    required this.investigation,
    required this.nature,
    required this.religion,
    required this.animalHandling,
    required this.insight,
    required this.medicine,
    required this.perception,
    required this.survival,
    required this.deception,
    required this.intimidation,
    required this.performance,
    required this.persuasion,
  });

  Character5eSkills copyWith({
    int? athletics,
    int? acrobatics,
    int? sleightOfHand,
    int? stealth,
    int? arcana,
    int? history,
    int? investigation,
    int? nature,
    int? religion,
    int? animalHandling,
    int? insight,
    int? medicine,
    int? perception,
    int? survival,
    int? deception,
    int? intimidation,
    int? performance,
    int? persuasion,
  }) {
    return Character5eSkills(
      athletics: athletics ?? this.athletics,
      acrobatics: acrobatics ?? this.acrobatics,
      sleightOfHand: sleightOfHand ?? this.sleightOfHand,
      stealth: stealth ?? this.stealth,
      arcana: arcana ?? this.arcana,
      history: history ?? this.history,
      investigation: investigation ?? this.investigation,
      nature: nature ?? this.nature,
      religion: religion ?? this.religion,
      animalHandling: animalHandling ?? this.animalHandling,
      insight: insight ?? this.insight,
      medicine: medicine ?? this.medicine,
      perception: perception ?? this.perception,
      survival: survival ?? this.survival,
      deception: deception ?? this.deception,
      intimidation: intimidation ?? this.intimidation,
      performance: performance ?? this.performance,
      persuasion: persuasion ?? this.persuasion,
    );
  }

  factory Character5eSkills.fromMap(Map<String, dynamic> map) {
    return Character5eSkills(
      athletics: map['athletics'] as int?,
      acrobatics: map['acrobatics'] as int?,
      sleightOfHand: map['sleightOfHand'] as int?,
      stealth: map['stealth'] as int?,
      arcana: map['arcana'] as int?,
      history: map['history'] as int?,
      investigation: map['investigation'] as int?,
      nature: map['nature'] as int?,
      religion: map['religion'] as int?,
      animalHandling: map['animalHandling'] as int?,
      insight: map['insight'] as int?,
      medicine: map['medicine'] as int?,
      perception: map['perception'] as int?,
      survival: map['survival'] as int?,
      deception: map['deception'] as int?,
      intimidation: map['intimidation'] as int?,
      performance: map['performance'] as int?,
      persuasion: map['persuasion'] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'athletics': athletics,
      'acrobatics': acrobatics,
      'sleightOfHand': sleightOfHand,
      'stealth': stealth,
      'arcana': arcana,
      'history': history,
      'investigation': investigation,
      'nature': nature,
      'religion': religion,
      'animalHandling': animalHandling,
      'insight': insight,
      'medicine': medicine,
      'perception': perception,
      'survival': survival,
      'deception': deception,
      'intimidation': intimidation,
      'performance': performance,
      'persuasion': persuasion,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eSkills &&
        other.athletics == athletics &&
        other.acrobatics == acrobatics &&
        other.sleightOfHand == sleightOfHand &&
        other.stealth == stealth &&
        other.arcana == arcana &&
        other.history == history &&
        other.investigation == investigation &&
        other.nature == nature &&
        other.religion == religion &&
        other.animalHandling == animalHandling &&
        other.insight == insight &&
        other.medicine == medicine &&
        other.perception == perception &&
        other.survival == survival &&
        other.deception == deception &&
        other.intimidation == intimidation &&
        other.performance == performance &&
        other.persuasion == persuasion;
  }

  @override
  int get hashCode {
    return athletics.hashCode ^
        acrobatics.hashCode ^
        sleightOfHand.hashCode ^
        stealth.hashCode ^
        arcana.hashCode ^
        history.hashCode ^
        investigation.hashCode ^
        nature.hashCode ^
        religion.hashCode ^
        animalHandling.hashCode ^
        insight.hashCode ^
        medicine.hashCode ^
        perception.hashCode ^
        survival.hashCode ^
        deception.hashCode ^
        intimidation.hashCode ^
        performance.hashCode ^
        persuasion.hashCode;
  }
}
