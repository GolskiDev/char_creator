import 'package:collection/collection.dart';
import 'package:flutter/services.dart';

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
    return const DeepCollectionEquality().hash(_abilityScores);
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

  int? get savingThrowModifier {
    if (_savingThrowModifier != null) {
      return _savingThrowModifier;
    }
    if (modifier != null) {
      return modifier;
    }
    return null;
  }

  //manually set modifier
  final int? _modifier;
  //manually set saving throw
  final int? _savingThrowModifier;

  const Character5eAbilityScore({
    required this.abilityScoreType,
    required this.value,
    int? modifier,
    int? savingThrowModifier,
  })  : _modifier = modifier,
        _savingThrowModifier = savingThrowModifier;

  /// Shortcut
  GameSystemViewModelItem get gameSystemViewModel =>
      abilityScoreType.gameSystemViewModel;

  Character5eAbilityScore copyWith({
    int? Function()? value,
    int? Function()? manuallySetModifier,
    int? Function()? manuallySetSavingThrowModifier,
  }) {
    return Character5eAbilityScore(
      abilityScoreType: abilityScoreType,
      value: value != null ? value() : this.value,
      modifier: manuallySetModifier != null ? manuallySetModifier() : _modifier,
      savingThrowModifier: manuallySetSavingThrowModifier != null
          ? manuallySetSavingThrowModifier()
          : _savingThrowModifier,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eAbilityScore &&
        other.abilityScoreType == abilityScoreType &&
        other.value == value &&
        other._modifier == _modifier &&
        other._savingThrowModifier == _savingThrowModifier;
  }

  @override
  int get hashCode {
    return abilityScoreType.hashCode ^
        value.hashCode ^
        _modifier.hashCode ^
        _savingThrowModifier.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      "abilityScoreType": abilityScoreType.name,
      "modifier": _modifier,
      "value": value,
      "savingThrowModifier": _savingThrowModifier,
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

  static TextInputFormatter get abilityScoreFormatter {
    return FilteringTextInputFormatter.allow(
      RegExp(r'[0-9]*$'),
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
  static TextInputType get textInputType {
    return TextInputType.numberWithOptions(
      signed: true,
      decimal: false,
    );
  }

  static TextInputFormatter get formatter {
    return FilteringTextInputFormatter.allow(
      RegExp(r'^[-]?[0-9]*$'),
    );
  }

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
