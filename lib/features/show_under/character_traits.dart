import 'package:collection/collection.dart';

class CharacterTraits {
  final Set<String> traitIds;

  CharacterTraits({
    required this.traitIds,
  });

  factory CharacterTraits.fromMap(Map<String, dynamic> map) {
    final mapContainsTraits = map.containsKey('traitIds');
    if (!mapContainsTraits) {
      return CharacterTraits(traitIds: {});
    }
    return CharacterTraits(
      traitIds: Set<String>.from(map['traitIds'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'traitIds': traitIds.toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CharacterTraits &&
        const DeepCollectionEquality().equals(
          other.traitIds,
          traitIds,
        );
  }

  @override
  int get hashCode {
    return const DeepCollectionEquality().hash(traitIds);
  }
}

final listOfCharacterTraits = [
  "character.abilityScores.constitution", //and others
  "character.age",
  "character.alignment",
  "character.size",
  "character.speed",
  "character.languages",
  "character.proficiencies",
  "character.proficiencies.tools",
  "character.proficiencies.weapons",
  "character.proficiencies.armor",
  "character.resistances",
  "character.savingThrows",
  "character.skills",
  "character.hitPoints",
  "character.hitDice",
];
