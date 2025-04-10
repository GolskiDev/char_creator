import 'srd_character_class.dart';

class PremadeCharacterClasses {
  static final List<Map<String, dynamic>> premadeCharacterClassesMaps = [
    for (var characterClass in CharacterClass.values)
      {
        "id": characterClass.name,
        "className": characterClass.toString(),
        "availableSpells": characterClass.classSpellsIds,
      }
  ];
}
