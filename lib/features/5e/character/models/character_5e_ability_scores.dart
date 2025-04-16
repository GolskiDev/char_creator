import 'package:collection/collection.dart';

enum Character5eAbilityScoreType {
  strength,
  dexterity,
  constitution,
  intelligence,
  wisdom,
  charisma;

  static Character5eAbilityScoreType fromString(String value) {
    final type = Character5eAbilityScoreType.values
        .firstWhereOrNull((abilityType) => abilityType.name == value);
    if (type != null) {
      return type;
    } else {
      throw Exception('Invalid ability score type: $value');
    }
  }
}

class Character5eAbilityScores {
  Map<Character5eAbilityScoreType, AbilityScore> get abilityScores =>
      _abilityScores;

  final Map<Character5eAbilityScoreType, AbilityScore> _abilityScores;

  Character5eAbilityScores._({
    required Map<Character5eAbilityScoreType, AbilityScore> abilityScores,
  }) : _abilityScores = abilityScores;

  factory Character5eAbilityScores.empty() {
    return Character5eAbilityScores._(
      abilityScores: {
        for (var abilityType in Character5eAbilityScoreType.values)
          abilityType: AbilityScore(
            abilityScoreType: abilityType,
            value: null,
          ),
      },
    );
  }

  Character5eAbilityScores copyWith({
    Map<Character5eAbilityScoreType, AbilityScore>? abilityScores,
  }) {
    return Character5eAbilityScores._(
      abilityScores: abilityScores ?? _abilityScores,
    );
  }

  factory Character5eAbilityScores.fromMap(Map<String, dynamic> map) {
    final abilityScores = (map['abilityScores'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        Character5eAbilityScoreType.fromString(key),
        AbilityScore.fromMap(value),
      ),
    );
    return Character5eAbilityScores._(
      abilityScores: abilityScores,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'abilityScores': _abilityScores.map(
        (key, ability) => MapEntry(key.name, ability.toMap()),
      ),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character5eAbilityScores &&
        const DeepCollectionEquality()
            .equals(other._abilityScores, _abilityScores);
  }

  @override
  int get hashCode {
    return _abilityScores.hashCode;
  }
}

class AbilityScore {
  final Character5eAbilityScoreType abilityScoreType;
  final int? value;

  const AbilityScore({
    required this.abilityScoreType,
    required this.value,
  });

  AbilityScore copyWith({
    int? value,
  }) {
    return AbilityScore(
      abilityScoreType: abilityScoreType,
      value: value ?? this.value,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AbilityScore &&
        other.abilityScoreType == abilityScoreType &&
        other.value == value;
  }

  @override
  int get hashCode {
    return abilityScoreType.hashCode ^ value.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      "abilityScoreType": abilityScoreType.name,
      "value": value,
    };
  }

  factory AbilityScore.fromMap(Map<String, dynamic> map) {
    return AbilityScore(
      abilityScoreType:
          Character5eAbilityScoreType.fromString(map['abilityScoreType']),
      value: map['value'] as int?,
    );
  }
}
