import 'package:char_creator/common/interfaces/identifiable.dart';
import 'package:char_creator/features/5e/character/models/character_5e_ability_scores.dart';
import 'package:char_creator/features/5e/character/models/character_5e_saving_throws.dart';
import 'package:char_creator/features/5e/character/models/character_5e_skills.dart';
import 'package:collection/collection.dart';

import 'character_5e_class_state_model_v1.dart';
import 'character_5e_others.dart';
import 'conditions_5e.dart';

class MultipleClassesWithSpellFoundException implements Exception {
  final String message;
  MultipleClassesWithSpellFoundException(this.message);
}

class Character5eModelV1 implements Identifiable {
  @override
  final String id;
  final String? _name;
  final int? _level;
  final Set<Character5eClassStateModelV1> _classesStates;
  Set<Character5eClassStateModelV1> get classesStates => _classesStates;

  final Character5eAbilityScores? abilityScores;
  final Character5eSavingThrows? character5eSavingThrows;
  final Character5eSkills? character5eSkills;
  final Conditions5e? conditions;
  final Character5eOthers? others;

  /// Custom spells for character not saved in class
  final Set<String> customSpellIds;
  final Set<String> preparedCustomSpellIds;

  Set<String> get knownSpells {
    return {
      ..._classesStates.map((e) => e.knownSpells).expand((element) => element),
      ...customSpellIds,
    };
  }

  Set<String> get preparedSpells => {
        ..._classesStates
            .map((e) => e.preparedSpells)
            .expand((element) => element),
        ...preparedCustomSpellIds,
      };

  String get name => _name ?? 'Unnamed Character';

  const Character5eModelV1._({
    required this.id,
    required String? name,
    int? level,
    Set<Character5eClassStateModelV1>? classesStates,
    this.customSpellIds = const {},
    this.preparedCustomSpellIds = const {},
    this.abilityScores,
    this.character5eSavingThrows,
    this.character5eSkills,
    this.conditions,
    this.others,
  })  : _level = level,
        _name = name,
        _classesStates = classesStates ?? const {};

  Character5eModelV1.empty({
    required String name,
    int? level,
    Set<Character5eClassStateModelV1>? classes,
    Set<String>? customSpellIds,
    Set<String>? preparedCustomSpellIds,
    Character5eAbilityScores? abilityScores,
    Character5eSavingThrows? character5eSavingThrows,
    Character5eSkills? character5eSkills,
    Conditions5e? conditions,
    Character5eOthers? others,
  }) : this._(
          id: IdGenerator.generateId(Character5eModelV1),
          name: name,
          level: level,
          classesStates: classes,
          customSpellIds: customSpellIds ?? const {},
          preparedCustomSpellIds: preparedCustomSpellIds ?? const {},
          abilityScores: abilityScores ?? Character5eAbilityScores.empty(),
          character5eSavingThrows: character5eSavingThrows,
          character5eSkills: character5eSkills ?? Character5eSkills.empty(),
          conditions: conditions,
          others: others,
        );

  Character5eModelV1 copyWith({
    String? name,
    int? level,
    Set<Character5eClassStateModelV1>? classesStates,
    Set<String>? customSpellIds,
    Set<String>? preparedCustomSpellIds,
    Character5eAbilityScores? abilityScores,
    Character5eSavingThrows? character5eSavingThrows,
    Character5eSkills? character5eSkills,
    Conditions5e? conditions,
    Character5eOthers? others,
  }) {
    return Character5eModelV1._(
      id: id,
      level: level ?? _level,
      name: name ?? _name,
      classesStates: classesStates ?? _classesStates,
      customSpellIds: customSpellIds ?? this.customSpellIds,
      preparedCustomSpellIds:
          preparedCustomSpellIds ?? this.preparedCustomSpellIds,
      abilityScores: abilityScores ?? this.abilityScores,
      character5eSavingThrows:
          character5eSavingThrows ?? this.character5eSavingThrows,
      character5eSkills: character5eSkills ?? this.character5eSkills,
      conditions: conditions ?? this.conditions,
      others: others ?? this.others,
    );
  }

  Character5eModelV1 addOrUpdateClass(
    Character5eClassStateModelV1 classState,
  ) {
    final existingClass = _classesStates.firstWhereOrNull(
      (element) => element.classModel.id == classState.classModel.id,
    );
    if (existingClass != null) {
      final updatedClass = existingClass.copyWith(
        classLevel: classState.classLevel,
        knownSpells: classState.knownSpells,
        preparedSpells: classState.preparedSpells,
      );
      _classesStates.remove(existingClass);
      _classesStates.add(updatedClass);
      return copyWith(
        classesStates: _classesStates,
      );
    } else {
      _classesStates.add(classState);
      return copyWith(
        classesStates: _classesStates,
      );
    }
  }

  Character5eModelV1 removeClass(
    Character5eClassStateModelV1 classState,
  ) {
    final existingClass = _classesStates.firstWhereOrNull(
      (element) => element.classModel.id == classState.classModel.id,
    );
    if (existingClass != null) {
      _classesStates.remove(existingClass);
      return copyWith(
        classesStates: _classesStates,
      );
    } else {
      throw Exception('Class not found');
    }
  }

  /// First tries to add the spell to the class
  /// then adds the spell to the character
  /// if the class doesn't have the spell
  /// throws [MultipleClassesWithSpellFoundException] if multiple classes with the same spell are found
  Character5eModelV1 addSpellForCharacter({
    required String spellId,
    String? classId,
  }) {
    if (classesStates.isNotEmpty) {
      final classesWithSpell = classesStates.where(
        (classesStates) =>
            classesStates.classModel.availableSpells.contains(spellId),
      );
      if (classesWithSpell.length > 1) {
        if (classId == null) {
          throw MultipleClassesWithSpellFoundException(
            'Multiple classes with spell $spellId found. Please specify classId.',
          );
        }

        /// if character doesn't have the class
        if (!classesWithSpell
            .any((element) => element.classModel.id == classId)) {
          throw Exception(
            'Character does not have the class $classId',
          );
        }

        /// if character has the class
        /// but the class doesn't have the spell
        /// This case - probably won't happen
        if (!classesWithSpell
            .firstWhere((element) => element.classModel.id == classId)
            .classModel
            .availableSpells
            .contains(spellId)) {
          throw Exception(
            'Class $classId does not have the spell $spellId',
          );
        }
        final classState = classesWithSpell
            .firstWhere((element) => element.classModel.id == classId);
        final updatedClass = classState.copyWith(
          knownSpells: {...classState.knownSpells, spellId},
          preparedSpells: {...classState.preparedSpells, spellId},
        );
        return addOrUpdateClass(updatedClass);
      }
      if (classesWithSpell.length == 1) {
        final classState = classesWithSpell.first;
        final updatedClass = classState.copyWith(
          knownSpells: {...classState.knownSpells, spellId},
          preparedSpells: {...classState.preparedSpells, spellId},
        );
        return addOrUpdateClass(updatedClass);
      }
    }
    return copyWith(
      customSpellIds: {...customSpellIds, spellId},
      preparedCustomSpellIds: {
        ...preparedCustomSpellIds,
        spellId,
      },
    );
  }

  Character5eModelV1 removeSpellForCharacter({
    required String spellId,
    required bool onlyUnprepare,
  }) {
    final classState = classesStates.firstWhereOrNull(
      (classesStates) =>
          classesStates.knownSpells.contains(spellId) ||
          classesStates.preparedSpells.contains(spellId),
    );
    if (classState != null) {
      if (onlyUnprepare) {
        final updatedClass = classState.copyWith(
          preparedSpells: {...classState.preparedSpells}..remove(spellId),
        );
        return addOrUpdateClass(updatedClass);
      }
      final updatedClass = classState.copyWith(
        knownSpells: {...classState.knownSpells}..remove(spellId),
        preparedSpells: {...classState.preparedSpells}..remove(spellId),
      );
      return addOrUpdateClass(updatedClass);
    }

    if (onlyUnprepare) {
      return copyWith(
        preparedCustomSpellIds: {...preparedCustomSpellIds}..remove(spellId),
      );
    } else {
      return copyWith(
        customSpellIds: {...customSpellIds}..remove(spellId),
        preparedCustomSpellIds: {...preparedCustomSpellIds}..remove(spellId),
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': _level,
      'name': _name,
      'classes': _classesStates.map((e) => e.toMap()).toList(),
      'customSpellIds': customSpellIds.toList(),
      'preparedCustomSpellIds': preparedCustomSpellIds.toList(),
      'abilityScores': abilityScores?.toMap(),
      'character5eSavingThrows': character5eSavingThrows?.toMap(),
      'character5eSkills': character5eSkills?.toMap(),
      'conditions': conditions?.toMap(),
      'others': others?.toMap(),
    };
  }

  factory Character5eModelV1.fromMap(Map<String, dynamic> json) {
    return Character5eModelV1._(
      id: json['id'],
      level: json['level'],
      name: json['name'],
      classesStates: (json['classes'] as List?)
          ?.map((e) => Character5eClassStateModelV1.fromMap(e))
          .toSet(),
      customSpellIds: Set<String>.from(json['customSpellIds'] ?? {}),
      preparedCustomSpellIds:
          Set<String>.from(json['preparedCustomSpellIds'] ?? {}),
      abilityScores: json['abilityScores'] != null
          ? Character5eAbilityScores.fromMap(
              json['abilityScores'] as Map<String, dynamic>)
          : null,
      character5eSavingThrows: json['character5eSavingThrows'] != null
          ? Character5eSavingThrows.fromMap(
              json['character5eSavingThrows'] as Map<String, dynamic>)
          : null,
      character5eSkills: json['character5eSkills'] != null
          ? Character5eSkills.fromMap(
              json['character5eSkills'] as Map<String, dynamic>)
          : null,
      conditions: json['conditions'] != null
          ? Conditions5e.fromMap(json['conditions'] as Map<String, dynamic>)
          : null,
      others: json['others'] != null
          ? Character5eOthers.fromMap(json['others'] as Map<String, dynamic>)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eModelV1 &&
        other.id == id &&
        other._level == _level &&
        other._name == _name &&
        SetEquality().equals(other._classesStates, _classesStates) &&
        SetEquality().equals(other.customSpellIds, customSpellIds) &&
        SetEquality()
            .equals(other.preparedCustomSpellIds, preparedCustomSpellIds) &&
        other.abilityScores == abilityScores &&
        other.character5eSavingThrows == character5eSavingThrows &&
        other.character5eSkills == character5eSkills &&
        other.conditions == conditions &&
        other.others == others;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        _level.hashCode ^
        _name.hashCode ^
        SetEquality().hash(_classesStates) ^
        SetEquality().hash(customSpellIds) ^
        SetEquality().hash(preparedCustomSpellIds) ^
        abilityScores.hashCode ^
        character5eSavingThrows.hashCode ^
        character5eSkills.hashCode ^
        conditions.hashCode ^
        others.hashCode;
  }
}
