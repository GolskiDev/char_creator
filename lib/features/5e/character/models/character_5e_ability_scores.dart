import 'package:collection/collection.dart';

import '../../game_system_view_model.dart';

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
  Map<Character5eAbilityScoreType, Character5eAbilityScore> get abilityScores =>
      _abilityScores;

  final Map<Character5eAbilityScoreType, Character5eAbilityScore>
      _abilityScores;

  Character5eAbilityScores._({
    required Map<Character5eAbilityScoreType, Character5eAbilityScore>
        abilityScores,
  }) : _abilityScores = abilityScores;

  factory Character5eAbilityScores.empty() {
    return Character5eAbilityScores._(
      abilityScores: {
        for (var abilityType in Character5eAbilityScoreType.values)
          abilityType: Character5eAbilityScore(
            abilityScoreType: abilityType,
            value: null,
          ),
      },
    );
  }

  Character5eAbilityScores copyWith({
    Map<Character5eAbilityScoreType, Character5eAbilityScore>? abilityScores,
  }) {
    return Character5eAbilityScores._(
      abilityScores: abilityScores ?? _abilityScores,
    );
  }

  factory Character5eAbilityScores.fromMap(Map<String, dynamic> map) {
    final abilityScores = (map['abilityScores'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(
        Character5eAbilityScoreType.fromString(key),
        Character5eAbilityScore.fromMap(value),
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

class Character5eAbilityScore {
  final Character5eAbilityScoreType abilityScoreType;
  final int? value;

  int? get modifier {
    if (_modifier != null) {
      return _modifier;
    }
    if (value == null) {
      return null;
    }
    return ((value! - 10) / 2).floor();
  }

  //manually set modifier
  final int? _modifier;

  const Character5eAbilityScore({
    required this.abilityScoreType,
    required this.value,
    int? modifier,
  }) : _modifier = modifier;

  /// Shortcut
  GameSystemViewModelItem get gameSystemViewModel =>
      abilityScoreType.gameSystemViewModel;

  Character5eAbilityScore copyWith({
    int? value,
    int? Function()? manuallySetModifier,
  }) {
    return Character5eAbilityScore(
      abilityScoreType: abilityScoreType,
      value: value ?? this.value,
      modifier: manuallySetModifier != null ? manuallySetModifier() : _modifier,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eAbilityScore &&
        other.abilityScoreType == abilityScoreType &&
        other.value == value &&
        other._modifier == _modifier;
  }

  @override
  int get hashCode {
    return abilityScoreType.hashCode ^ value.hashCode ^ _modifier.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      "abilityScoreType": abilityScoreType.name,
      "modifier": _modifier,
      "value": value,
    };
  }

  factory Character5eAbilityScore.fromMap(Map<String, dynamic> map) {
    return Character5eAbilityScore(
      abilityScoreType:
          Character5eAbilityScoreType.fromString(map['abilityScoreType']),
      value: map['value'] as int?,
      modifier: map['modifier'] as int?,
    );
  }
}

extension AbilityScoreGameSystemViewModel on Character5eAbilityScoreType {
  GameSystemViewModelItem get gameSystemViewModel {
    return switch (this) {
      Character5eAbilityScoreType.strength => GameSystemViewModel.strength,
      Character5eAbilityScoreType.dexterity => GameSystemViewModel.dexterity,
      Character5eAbilityScoreType.constitution =>
        GameSystemViewModel.constitution,
      Character5eAbilityScoreType.intelligence =>
        GameSystemViewModel.intelligence,
      Character5eAbilityScoreType.wisdom => GameSystemViewModel.wisdom,
      Character5eAbilityScoreType.charisma => GameSystemViewModel.charisma,
    };
  }
}

class Modifier {
  static String display(int? modifier) {
    if (modifier == null) {
      return '';
    }
    if (modifier > 0) {
      return '+$modifier';
    } else if (modifier < 0) {
      return '$modifier';
    } else {
      return '0';
    }
  }
}
