class Character5eAbilityScores {
  final Strength strength;
  final Dexterity dexterity;
  final Constitution constitution;
  final Intelligence intelligence;
  final Wisdom wisdom;
  final Charisma charisma;

  Character5eAbilityScores({
    required this.strength,
    required this.dexterity,
    required this.constitution,
    required this.intelligence,
    required this.wisdom,
    required this.charisma,
  });

  factory Character5eAbilityScores.fromJson(Map<String, dynamic> json) {
    return Character5eAbilityScores(
      strength: Strength(score: json['strength']),
      dexterity: Dexterity(score: json['dexterity']),
      constitution: Constitution(score: json['constitution']),
      intelligence: Intelligence(score: json['intelligence']),
      wisdom: Wisdom(score: json['wisdom']),
      charisma: Charisma(score: json['charisma']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'strength': strength.score,
      'dexterity': dexterity.score,
      'constitution': constitution.score,
      'intelligence': intelligence.score,
      'wisdom': wisdom.score,
      'charisma': charisma.score,
    };
  }
}

sealed class Character5eAbilityScore {
  final int score;

  Character5eAbilityScore({
    required this.score,
  });
}

class Strength extends Character5eAbilityScore {
  Strength({
    required super.score,
  });
}

class Dexterity extends Character5eAbilityScore {
  Dexterity({
    required super.score,
  });
}

class Constitution extends Character5eAbilityScore {
  Constitution({
    required super.score,
  });
}

class Intelligence extends Character5eAbilityScore {
  Intelligence({
    required super.score,
  });
}

class Wisdom extends Character5eAbilityScore {
  Wisdom({
    required super.score,
  });
}

class Charisma extends Character5eAbilityScore {
  Charisma({
    required super.score,
  });
}
