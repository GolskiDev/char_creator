import 'package:collection/collection.dart';

import '../../../../../features/5e/game_system_view_model.dart';
import 'character_5e_ability_scores.dart';

enum Character5eSkillType {
  athletics(Character5eAbilityScoreType.strength),
  acrobatics(Character5eAbilityScoreType.dexterity),
  sleightOfHand(Character5eAbilityScoreType.dexterity),
  stealth(Character5eAbilityScoreType.dexterity),
  arcana(Character5eAbilityScoreType.intelligence),
  history(Character5eAbilityScoreType.intelligence),
  investigation(Character5eAbilityScoreType.intelligence),
  nature(Character5eAbilityScoreType.intelligence),
  religion(Character5eAbilityScoreType.intelligence),
  animalHandling(Character5eAbilityScoreType.wisdom),
  insight(Character5eAbilityScoreType.wisdom),
  medicine(Character5eAbilityScoreType.wisdom),
  perception(Character5eAbilityScoreType.wisdom),
  survival(Character5eAbilityScoreType.wisdom),
  deception(Character5eAbilityScoreType.charisma),
  intimidation(Character5eAbilityScoreType.charisma),
  performance(Character5eAbilityScoreType.charisma),
  persuasion(Character5eAbilityScoreType.charisma);

  final Character5eAbilityScoreType associatedAbility;

  const Character5eSkillType(this.associatedAbility);
}

extension Character5eSkillTypeExtension on Character5eSkillType {
  GameSystemViewModelItem get gameSystemViewModel {
    return switch (this) {
      Character5eSkillType.athletics => GameSystemViewModel.athletics,
      Character5eSkillType.acrobatics => GameSystemViewModel.acrobatics,
      Character5eSkillType.sleightOfHand => GameSystemViewModel.sleightOfHand,
      Character5eSkillType.stealth => GameSystemViewModel.stealth,
      Character5eSkillType.arcana => GameSystemViewModel.arcana,
      Character5eSkillType.history => GameSystemViewModel.history,
      Character5eSkillType.investigation => GameSystemViewModel.investigation,
      Character5eSkillType.nature => GameSystemViewModel.nature,
      Character5eSkillType.religion => GameSystemViewModel.religion,
      Character5eSkillType.animalHandling => GameSystemViewModel.animalHandling,
      Character5eSkillType.insight => GameSystemViewModel.insight,
      Character5eSkillType.medicine => GameSystemViewModel.medicine,
      Character5eSkillType.perception => GameSystemViewModel.perception,
      Character5eSkillType.survival => GameSystemViewModel.survival,
      Character5eSkillType.deception => GameSystemViewModel.deception,
      Character5eSkillType.intimidation => GameSystemViewModel.intimidation,
      Character5eSkillType.performance => GameSystemViewModel.performance,
      Character5eSkillType.persuasion => GameSystemViewModel.persuasion,
    };
  }
}

class Character5eSkill {
  final Character5eSkillType skillType;
  final int? _manualModifier;

  bool get isCustomModifierUsed => _manualModifier != null;

  const Character5eSkill({
    required this.skillType,
    int? manualModifier,
  }) : _manualModifier = manualModifier;

  int? getModifier(Character5eAbilityScores? abilityScores) {
    if (_manualModifier != null) {
      return _manualModifier;
    }
    return abilityScores?.abilityScores[skillType.associatedAbility]?.modifier;
  }

  GameSystemViewModelItem get gameSystemViewModel =>
      skillType.gameSystemViewModel;

  Character5eSkill copyWith({
    int? Function()? manuallySetModifier,
  }) {
    return Character5eSkill(
      skillType: skillType,
      manualModifier:
          manuallySetModifier != null ? manuallySetModifier() : _manualModifier,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'skillType': skillType.name,
      if (_manualModifier != null) 'manualModifier': _manualModifier,
    };
  }

  factory Character5eSkill.fromMap(Map<String, dynamic> map) {
    return Character5eSkill(
      skillType: Character5eSkillType.values
          .firstWhere((e) => e.name == map['skillType']),
      manualModifier: map['manualModifier'] as int?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eSkill &&
        other.skillType == skillType &&
        other._manualModifier == _manualModifier;
  }

  @override
  int get hashCode => skillType.hashCode ^ _manualModifier.hashCode;
}

class Character5eSkills {
  final Map<Character5eSkillType, Character5eSkill> skills;

  const Character5eSkills({required this.skills});

  Character5eSkills copyWith({
    Map<Character5eSkillType, Character5eSkill>? skills,
  }) {
    return Character5eSkills(
      skills: skills ?? this.skills,
    );
  }

  factory Character5eSkills.empty() {
    return Character5eSkills(
      skills: {
        for (var skillType in Character5eSkillType.values)
          skillType: Character5eSkill(skillType: skillType),
      },
    );
  }

  factory Character5eSkills.fromMap(Map<String, dynamic> map) {
    return Character5eSkills(
      skills: map.map(
        (key, value) => MapEntry(
          Character5eSkillType.values.firstWhere((e) => e.name == key),
          Character5eSkill.fromMap(value),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return skills.map(
      (key, value) => MapEntry(key.name, value.toMap()),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eSkills &&
        DeepCollectionEquality().equals(other.skills, skills);
  }

  @override
  int get hashCode => DeepCollectionEquality().hash(skills);
}
