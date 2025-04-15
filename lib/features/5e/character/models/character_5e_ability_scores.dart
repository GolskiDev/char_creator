class Character5eAbilityScores {
  final int? strength;
  final int? dexterity;
  final int? constitution;
  final int? intelligence;
  final int? wisdom;
  final int? charisma;

  const Character5eAbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  Character5eAbilityScores copyWith({
    int? strength,
    int? dexterity,
    int? constitution,
    int? intelligence,
    int? wisdom,
    int? charisma,
  }) {
    return Character5eAbilityScores(
      strength: strength ?? this.strength,
      dexterity: dexterity ?? this.dexterity,
      constitution: constitution ?? this.constitution,
      intelligence: intelligence ?? this.intelligence,
      wisdom: wisdom ?? this.wisdom,
      charisma: charisma ?? this.charisma,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "strength": strength,
      "dexterity": dexterity,
      "constitution": constitution,
      "intelligence": intelligence,
      "wisdom": wisdom,
      "charisma": charisma,
    };
  }

  factory Character5eAbilityScores.fromMap(Map<String, dynamic> map) {
    return Character5eAbilityScores(
      strength: map["strength"] as int?,
      dexterity: map["dexterity"] as int?,
      constitution: map["constitution"] as int?,
      intelligence: map["intelligence"] as int?,
      wisdom: map["wisdom"] as int?,
      charisma: map["charisma"] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eAbilityScores &&
        other.strength == strength &&
        other.dexterity == dexterity &&
        other.constitution == constitution &&
        other.intelligence == intelligence &&
        other.wisdom == wisdom &&
        other.charisma == charisma;
  }

  @override
  int get hashCode {
    return strength.hashCode ^
        dexterity.hashCode ^
        constitution.hashCode ^
        intelligence.hashCode ^
        wisdom.hashCode ^
        charisma.hashCode;
  }
}
