import 'package:spells_and_tools/common/interfaces/identifiable.dart';

sealed class SpellCastingTime implements Identifiable {
  static SpellCastingTime fromString(String castingTime) {
    switch (castingTime.toLowerCase()) {
      case '1 action':
        return OneAction();
      case '1 bonus action':
        return OneBonusAction();
      case '1 reaction':
      case '1 reaction, which you take when you see a creature within 60 feet of you casting a spell':
      case '1 reaction, which you take in response to being damaged by a creature within 60 feet of you that you can see':
        return OneReaction();
      case '1 minute':
      case 'up to 1 minute':
        return OneMinute();
      case '10 minutes':
      case 'up to 10 minutes':
        return TenMinutes();
      case '1 hour':
      case 'up to 1 hour':
        return OneHour();
      case '8 hours':
      case 'up to 8 hours':
        return EightHours();
      case '24 hours':
        return TwentyFourHours();
      case '12 hours':
        return TwelveHours();
      default:
        return SpellCastingTimeCustom();
    }
  }

  int compareTo(SpellCastingTime other) {
    final orderedCastingTimes = [
      OneBonusAction(),
      SpellCastingTimeCustom(),
      OneAction(),
      OneReaction(),
      OneMinute(),
      TenMinutes(),
      OneHour(),
      EightHours(),
      TwentyFourHours(),
      TwelveHours(),
    ];

    return orderedCastingTimes.indexWhere((d) => d == this) -
        orderedCastingTimes.indexWhere((d) => d == other);
  }

  static List<SpellCastingTime> get all => [
        OneAction(),
        OneBonusAction(),
        OneReaction(),
        OneMinute(),
        TenMinutes(),
        OneHour(),
        EightHours(),
        TwentyFourHours(),
        TwelveHours(),
        SpellCastingTimeCustom(),
      ];
}

class OneAction extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '1 action';

  @override
  bool operator ==(Object other) {
    return other is OneAction;
  }

  @override
  int get hashCode => 1;
}

class OneBonusAction extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '1 bonus action';

  @override
  bool operator ==(Object other) {
    return other is OneBonusAction;
  }

  @override
  int get hashCode => 2;
}

class OneReaction extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '1 reaction';

  @override
  bool operator ==(Object other) {
    return other is OneReaction;
  }

  @override
  int get hashCode => 3;
}

class OneMinute extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '1 minute';

  @override
  bool operator ==(Object other) {
    return other is OneMinute;
  }

  @override
  int get hashCode => 4;
}

class TenMinutes extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '10 minutes';

  @override
  bool operator ==(Object other) {
    return other is TenMinutes;
  }

  @override
  int get hashCode => 5;
}

class OneHour extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '1 hour';

  @override
  bool operator ==(Object other) {
    return other is OneHour;
  }

  @override
  int get hashCode => 6;
}

class EightHours extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '8 hours';

  @override
  bool operator ==(Object other) {
    return other is EightHours;
  }

  @override
  int get hashCode => 7;
}

class TwentyFourHours extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '24 hours';

  @override
  bool operator ==(Object other) {
    return other is TwentyFourHours;
  }

  @override
  int get hashCode => 9;
}

class TwelveHours extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => '12 hours';

  @override
  bool operator ==(Object other) {
    return other is TwelveHours;
  }

  @override
  int get hashCode => 11;
}

class SpellCastingTimeCustom extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() => 'Custom';
}
