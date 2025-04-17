import '../../game_system_view_model.dart';

enum Condition5eType {
  blinded,
  charmed,
  deafened,
  frightened,
  grappled,
  incapacitated,
  invisible,
  paralyzed,
  petrified,
  poisoned,
  prone,
  restrained,
  stunned,
  unconscious,
}

enum ExhaustionLevel5e {
  level0,
  level1,
  level2,
  level3,
  level4,
  level5,
  level6,
}

class Conditions5e {
  final Set<Condition5eType> conditions;
  final ExhaustionLevel5e exhaustionLevel;

  Conditions5e({
    this.conditions = const {},
    this.exhaustionLevel = ExhaustionLevel5e.level0,
  });

  Conditions5e copyWith({
    Set<Condition5eType>? conditions,
    ExhaustionLevel5e? exhaustionLevel,
  }) {
    return Conditions5e(
      conditions: conditions ?? this.conditions,
      exhaustionLevel: exhaustionLevel ?? this.exhaustionLevel,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'conditions': conditions.map((e) => e.name).toList(),
      'exhaustionLevel': exhaustionLevel.name,
    };
  }

  factory Conditions5e.fromMap(Map<String, dynamic> map) {
    return Conditions5e(
      conditions: (map['conditions'] as List)
          .map((e) =>
              Condition5eType.values.firstWhere((element) => element.name == e))
          .toSet(),
      exhaustionLevel: ExhaustionLevel5e.values.firstWhere(
        (element) => element.name == map['exhaustionLevel'],
      ),
    );
  }
}

extension Condition5eTypeExtension on Condition5eType {
  GameSystemViewModelItem get gameSystemViewModel {
    switch (this) {
      case Condition5eType.blinded:
        return GameSystemViewModel.blinded;
      case Condition5eType.charmed:
        return GameSystemViewModel.charmed;
      case Condition5eType.deafened:
        return GameSystemViewModel.deafened;
      case Condition5eType.frightened:
        return GameSystemViewModel.frightened;
      case Condition5eType.grappled:
        return GameSystemViewModel.grappled;
      case Condition5eType.incapacitated:
        return GameSystemViewModel.incapacitated;
      case Condition5eType.invisible:
        return GameSystemViewModel.invisible;
      case Condition5eType.paralyzed:
        return GameSystemViewModel.paralyzed;
      case Condition5eType.petrified:
        return GameSystemViewModel.petrified;
      case Condition5eType.poisoned:
        return GameSystemViewModel.poisoned;
      case Condition5eType.prone:
        return GameSystemViewModel.prone;
      case Condition5eType.restrained:
        return GameSystemViewModel.restrained;
      case Condition5eType.stunned:
        return GameSystemViewModel.stunned;
      case Condition5eType.unconscious:
        return GameSystemViewModel.unconscious;
    }
  }
}

extension ExhaustionLevel5eExtension on ExhaustionLevel5e {
  GameSystemViewModelItem get gameSystemViewModel {
    switch (this) {
      case ExhaustionLevel5e.level0:
        return GameSystemViewModel.exhaustionLevel0;
      case ExhaustionLevel5e.level1:
        return GameSystemViewModel.exhaustionLevel1;
      case ExhaustionLevel5e.level2:
        return GameSystemViewModel.exhaustionLevel2;
      case ExhaustionLevel5e.level3:
        return GameSystemViewModel.exhaustionLevel3;
      case ExhaustionLevel5e.level4:
        return GameSystemViewModel.exhaustionLevel4;
      case ExhaustionLevel5e.level5:
        return GameSystemViewModel.exhaustionLevel5;
      case ExhaustionLevel5e.level6:
        return GameSystemViewModel.exhaustionLevel6;
    }
  }
}
