import 'package:char_creator/features/character/character_temp_data_source.dart';

import 'character.dart';

class UncategorizedUseCases {
  updateCharacterBasedOnResponse(
    Map<String, dynamic> response,
    CharacterTempDataSource dataSource,
  ) async {
    try {
      Character character =
          (await dataSource.getAllCharactersStream().first).first;
      final characterTraits = response['character'];
      characterTraits.forEach((traitId, traitValue) {
        character = addToCharacter(traitId, traitValue, character);
      });
      dataSource.updateCharacter(character);
    } catch (e) {
      print(e);
      throw Exception('Error updating character based on response');
    }
  }

  Character addToCharacter(
    String traitId,
    dynamic traitValue,
    Character character,
  ) {
    // handle case traitVAlue is a list
    if (traitValue is List) {
      traitValue.forEach((trait) {
        addToCharacter(traitId, trait, character);
      });
      return character;
    }
    switch (traitId) {
      case 'name':
        return character.copyWith(name: traitValue);
      case 'race':
        return character.copyWith(race: traitValue);
      case 'characterClass':
        return character.copyWith(characterClass: traitValue);
      case 'alignment':
        return character.copyWith(alignment: traitValue);
      case 'appearance':
        return character.copyWith(appearance: traitValue);
      case 'treasure':
        return character.copyWith(treasure: traitValue);
      case 'characterHistory':
        return character.copyWith(characterHistory: traitValue);
      case 'skills':
        final skills = character.skills ?? [];
        return character.copyWith(skills: [...skills, traitValue]);
      case 'equipment':
        final equipment = character.equipment ?? [];
        return character.copyWith(equipment: [...equipment, traitValue]);
      case 'personalityTraits':
        final personalityTraits = character.personalityTraits ?? [];
        return character
            .copyWith(personalityTraits: [...personalityTraits, traitValue]);
      case 'ideals':
        final ideals = character.ideals ?? [];
        return character.copyWith(ideals: [...ideals, traitValue]);
      case 'bonds':
        final bonds = character.bonds ?? [];
        return character.copyWith(bonds: [...bonds, traitValue]);
      case 'flaws':
        final flaws = character.flaws ?? [];
        return character.copyWith(flaws: [...flaws, traitValue]);
      case 'alliesAndOrganizations':
        final alliesAndOrganizations = character.alliesAndOrganizations ?? [];
        return character.copyWith(
            alliesAndOrganizations: [...alliesAndOrganizations, traitValue]);
      default:
        return character;
    }
  }
}
