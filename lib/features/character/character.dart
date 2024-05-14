class Character {
  final String id;
  final String? name;
  final String? race;
  final String? characterClass;
  final List<String>? skills;
  final List<String>? equipment;
  final String? alignment;
  final List<String>? personalityTraits;
  final List<String>? ideals;
  final List<String>? bonds;
  final List<String>? flaws;
  final String? appearance;
  final List<String>? alliesAndOrganizations;
  final String? treasure;
  final String? characterHistory;

  Character({
    required this.id,
    this.name,
    this.race,
    this.characterClass,
    this.skills,
    this.equipment,
    this.alignment,
    this.personalityTraits,
    this.ideals,
    this.bonds,
    this.flaws,
    this.appearance,
    this.alliesAndOrganizations,
    this.treasure,
    this.characterHistory,
  });

  Character copyWith({
    String? name,
    String? race,
    String? characterClass,
    List<String>? skills,
    List<String>? equipment,
    String? alignment,
    List<String>? personalityTraits,
    List<String>? ideals,
    List<String>? bonds,
    List<String>? flaws,
    String? appearance,
    List<String>? alliesAndOrganizations,
    List<String>? additionalFeaturesAndTraits,
    String? treasure,
    String? characterHistory,
  }) {
    return Character(
      id: id,
      name: name ?? this.name,
      race: race ?? this.race,
      characterClass: characterClass ?? this.characterClass,
      skills: skills ?? this.skills,
      equipment: equipment ?? this.equipment,
      alignment: alignment ?? this.alignment,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      ideals: ideals ?? this.ideals,
      bonds: bonds ?? this.bonds,
      flaws: flaws ?? this.flaws,
      appearance: appearance ?? this.appearance,
      alliesAndOrganizations: alliesAndOrganizations ?? this.alliesAndOrganizations,
      treasure: treasure ?? this.treasure,
      characterHistory: characterHistory ?? this.characterHistory,
    );
  }
}
