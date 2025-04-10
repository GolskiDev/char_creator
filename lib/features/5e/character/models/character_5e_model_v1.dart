import 'package:char_creator/common/interfaces/identifiable.dart';
import 'package:collection/collection.dart';

import 'character_5e_class_state_model_v1.dart';

class Character5eModelV1 implements Identifiable {
  @override
  final String id;
  final String? _name;
  final int? _level;
  final Set<Character5eClassStateModelV1> _classes;
  Set<Character5eClassStateModelV1> get classes => _classes;

  /// Custom spells for character not saved in class
  final Set<String> customSpellIds;
  final Set<String> preparedCustomSpellIds;

  Set<String> get knownSpells {
    return {
      ..._classes.map((e) => e.knownSpells).expand((element) => element),
      ...customSpellIds,
    };
  }

  Set<String> get preparedSpells => {
        ..._classes.map((e) => e.preparedSpells).expand((element) => element),
        ...preparedCustomSpellIds,
      };

  String get name => _name ?? 'Unnamed Character';

  const Character5eModelV1._({
    required this.id,
    required String? name,
    int? level,
    Set<Character5eClassStateModelV1>? classes,
    this.customSpellIds = const {},
    this.preparedCustomSpellIds = const {},
  })  : _level = level,
        _name = name,
        _classes = classes ?? const {};

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
          classes: classes ?? const {},
          customSpellIds: customSpellIds ?? const {},
          preparedCustomSpellIds: preparedCustomSpellIds ?? const {},
        );

  Character5eModelV1 copyWith({
    String? name,
    int? level,
    Set<Character5eClassStateModelV1>? classes,
    Set<String>? customSpellIds,
    Set<String>? preparedCustomSpellIds,
  }) {
    return Character5eModelV1._(
      id: id,
      level: level ?? _level,
      name: name ?? _name,
      classes: classes ?? _classes,
      customSpellIds: customSpellIds ?? this.customSpellIds,
      preparedCustomSpellIds:
          preparedCustomSpellIds ?? this.preparedCustomSpellIds,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': _level,
      'name': _name,
      'classes': _classes.map((e) => e.toMap()).toList(),
      'customSpellIds': customSpellIds.toList(),
      'preparedCustomSpellIds': preparedCustomSpellIds.toList(),
    };
  }

  factory Character5eModelV1.fromJson(Map<String, dynamic> json) {
    return Character5eModelV1._(
      id: json['id'],
      level: json['level'],
      name: json['name'],
      classes: (json['classes'] as List?)
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
        SetEquality().equals(other._classes, _classes) &&
        SetEquality().equals(other.customSpellIds, customSpellIds) &&
        SetEquality()
            .equals(other.preparedCustomSpellIds, preparedCustomSpellIds);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        _level.hashCode ^
        _name.hashCode ^
        SetEquality().hash(_classes) ^
        SetEquality().hash(customSpellIds) ^
        SetEquality().hash(preparedCustomSpellIds);
  }
}
