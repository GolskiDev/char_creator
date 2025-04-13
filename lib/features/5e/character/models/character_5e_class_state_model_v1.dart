import 'package:collection/collection.dart';

import 'character_5e_class_model_v1.dart';

class Character5eClassStateModelV1 {
  final int classLevel;
  final ICharacter5eClassModelV1 classModel;
  final Set<String> knownSpells;
  final Set<String> preparedSpells;

  const Character5eClassStateModelV1._({
    required this.classModel,
    required this.classLevel,
    this.knownSpells = const {},
    this.preparedSpells = const {},
  });

  Character5eClassStateModelV1.empty({
    required ICharacter5eClassModelV1 classModel,
    int classLevel = 1,
    Set<String>? knownSpells,
    Set<String>? preparedSpells,
  }) : this._(
          classModel: classModel,
          classLevel: classLevel,
          knownSpells: knownSpells ?? const {},
          preparedSpells: preparedSpells ?? const {},
        );

  Character5eClassStateModelV1 copyWith({
    int? classLevel,
    Set<String>? knownSpells,
    Set<String>? preparedSpells,
  }) {
    return Character5eClassStateModelV1._(
      classLevel: classLevel ?? this.classLevel,
      classModel: classModel,
      knownSpells: knownSpells ?? this.knownSpells,
      preparedSpells: preparedSpells ?? this.preparedSpells,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eClassStateModelV1 &&
        other.classModel == classModel &&
        other.classLevel == classLevel &&
        SetEquality().equals(other.knownSpells, knownSpells) &&
        SetEquality().equals(other.preparedSpells, preparedSpells);
  }

  @override
  int get hashCode {
    return classModel.hashCode ^
        classLevel.hashCode ^
        SetEquality().hash(knownSpells) ^
        SetEquality().hash(preparedSpells);
  }

  Map<String, dynamic> toMap() {
    return {
      'classLevel': classLevel,
      'classModel': classModel.toMap(),
      'knownSpells': knownSpells.toList(),
      'preparedSpells': preparedSpells.toList(),
    };
  }

  factory Character5eClassStateModelV1.fromMap(Map<String, dynamic> json) {
    return Character5eClassStateModelV1._(
      classLevel: json['classLevel'],
      classModel: Character5eCustomClassModelV1.fromMap(json['classModel']),
      knownSpells: Set<String>.from(json['knownSpells']),
      preparedSpells: Set<String>.from(json['preparedSpells']),
    );
  }
}
