class Character5eSavingThrows {
  final int? savingThrowStrength;
  final int? savingThrowDexterity;
  final int? savingThrowConstitution;
  final int? savingThrowIntelligence;
  final int? savingThrowWisdom;
  final int? savingThrowCharisma;

  Character5eSavingThrows({
    required this.savingThrowStrength,
    required this.savingThrowDexterity,
    required this.savingThrowConstitution,
    required this.savingThrowIntelligence,
    required this.savingThrowWisdom,
    required this.savingThrowCharisma,
  });

  Character5eSavingThrows copyWith({
    int? savingThrowStrength,
    int? savingThrowDexterity,
    int? savingThrowConstitution,
    int? savingThrowIntelligence,
    int? savingThrowWisdom,
    int? savingThrowCharisma,
  }) {
    return Character5eSavingThrows(
      savingThrowStrength: savingThrowStrength ?? this.savingThrowStrength,
      savingThrowDexterity: savingThrowDexterity ?? this.savingThrowDexterity,
      savingThrowConstitution:
          savingThrowConstitution ?? this.savingThrowConstitution,
      savingThrowIntelligence:
          savingThrowIntelligence ?? this.savingThrowIntelligence,
      savingThrowWisdom: savingThrowWisdom ?? this.savingThrowWisdom,
      savingThrowCharisma: savingThrowCharisma ?? this.savingThrowCharisma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'savingThrowStrength': savingThrowStrength,
      'savingThrowDexterity': savingThrowDexterity,
      'savingThrowConstitution': savingThrowConstitution,
      'savingThrowIntelligence': savingThrowIntelligence,
      'savingThrowWisdom': savingThrowWisdom,
      'savingThrowCharisma': savingThrowCharisma,
    };
  }

  factory Character5eSavingThrows.fromMap(Map<String, dynamic> map) {
    return Character5eSavingThrows(
      savingThrowStrength: map['savingThrowStrength'] as int?,
      savingThrowDexterity: map['savingThrowDexterity'] as int?,
      savingThrowConstitution: map['savingThrowConstitution'] as int?,
      savingThrowIntelligence: map['savingThrowIntelligence'] as int?,
      savingThrowWisdom: map['savingThrowWisdom'] as int?,
      savingThrowCharisma: map['savingThrowCharisma'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eSavingThrows &&
        other.savingThrowStrength == savingThrowStrength &&
        other.savingThrowDexterity == savingThrowDexterity &&
        other.savingThrowConstitution == savingThrowConstitution &&
        other.savingThrowIntelligence == savingThrowIntelligence &&
        other.savingThrowWisdom == savingThrowWisdom &&
        other.savingThrowCharisma == savingThrowCharisma;
  }

  @override
  int get hashCode {
    return savingThrowStrength.hashCode ^
        savingThrowDexterity.hashCode ^
        savingThrowConstitution.hashCode ^
        savingThrowIntelligence.hashCode ^
        savingThrowWisdom.hashCode ^
        savingThrowCharisma.hashCode;
  }
}
