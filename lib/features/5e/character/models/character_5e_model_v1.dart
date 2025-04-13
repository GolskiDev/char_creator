import 'package:char_creator/common/interfaces/identifiable.dart';
import 'package:collection/collection.dart';

import 'character_5e_class_state_model_v1.dart';

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
  })  : _level = level,
        _name = name,
        _classesStates = classesStates ?? const {};

  Character5eModelV1.empty({
    required String name,
    int? level,
    Set<Character5eClassStateModelV1>? classes,
    Set<String>? customSpellIds,
    Set<String>? preparedCustomSpellIds,
  }) : this._(
          id: IdGenerator.generateId(Character5eModelV1),
          name: name,
          level: level,
          classesStates: classes ?? const {},
          customSpellIds: customSpellIds ?? const {},
          preparedCustomSpellIds: preparedCustomSpellIds ?? const {},
        );

  Character5eModelV1 copyWith({
    String? name,
    int? level,
    Set<Character5eClassStateModelV1>? classesStates,
    Set<String>? customSpellIds,
    Set<String>? preparedCustomSpellIds,
  }) {
    return Character5eModelV1._(
      id: id,
      level: level ?? _level,
      name: name ?? _name,
      classesStates: _classesStates,
      customSpellIds: customSpellIds ?? this.customSpellIds,
      preparedCustomSpellIds:
          preparedCustomSpellIds ?? this.preparedCustomSpellIds,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': _level,
      'name': _name,
      'classes': _classesStates.map((e) => e.toMap()).toList(),
      'customSpellIds': customSpellIds.toList(),
      'preparedCustomSpellIds': preparedCustomSpellIds.toList(),
    };
  }

  factory Character5eModelV1.fromJson(Map<String, dynamic> json) {
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
            .equals(other.preparedCustomSpellIds, preparedCustomSpellIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        _level.hashCode ^
        _name.hashCode ^
        SetEquality().hash(_classesStates) ^
        SetEquality().hash(customSpellIds) ^
        SetEquality().hash(preparedCustomSpellIds);
  }
}
