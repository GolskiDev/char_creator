import 'package:spells_and_tools/features/5e/character/models/character_5e_ability_scores.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_class_model_v1.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_class_state_model_v1.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_model_v1.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_note.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_others.dart';
import 'package:spells_and_tools/features/5e/character/models/character_5e_skills.dart';
import 'package:spells_and_tools/features/5e/character/models/conditions_5e.dart';
import 'package:spells_and_tools/features/show_under/character_traits.dart';
import 'package:spells_and_tools/features/show_under/json_enums/character_enums.dart';

// Example mock character for use in ExampleCharacterPage2
final exampleCharacter5e = Character5eModelV1.empty(
  name: 'Durnan',
  level: 5,
  abilityScores: Character5eAbilityScores.fromMap(
    {
      'abilityScores': {
        'strength': {'abilityScoreType': 'strength', 'value': 16},
        'dexterity': {'abilityScoreType': 'dexterity', 'value': 12},
        'constitution': {'abilityScoreType': 'constitution', 'value': 14},
        'intelligence': {'abilityScoreType': 'intelligence', 'value': 10},
        'wisdom': {'abilityScoreType': 'wisdom', 'value': 13},
        'charisma': {'abilityScoreType': 'charisma', 'value': 11},
      },
    },
  ),
  character5eSkills: Character5eSkills.empty(),
  conditions: Conditions5e(),
  spellSlots: null,
  notes: Character5eNotes.empty(),
  others: Character5eOtherProps(
    maxHP: 42,
    temporaryHP: 5,
    currentHP: 37,
    ac: 17,
    currentSpeed: 30,
    initiative: 2,
  ),
  characterTraits: CharacterTraits(traitIds: {'darkvision', 'brave'}),
  characterEnums: CharacterEnums(),
  classes: {
    Character5eClassStateModelV1.empty(
      classModel: Character5eCustomClassModelV1.fromMap({
        'id': 'fighter',
        'className': 'Fighter',
        'availableSpells': <String>[],
      }),
      classLevel: 5,
      knownSpells: {'fireball', 'magic_missile', 'shield'},
      preparedSpells: {'fireball', 'magic_missile', 'shield'},
    ),
  },
);
