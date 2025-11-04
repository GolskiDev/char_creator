import 'package:spells_and_tools/common/interfaces/identifiable.dart';

sealed class SpellDuration implements Identifiable {
  static SpellDuration fromString(String duration) {
    switch (duration.toLowerCase()) {
      case 'instantaneous':
        return Instantaneous();
      case '1 round':
        return OneRound();
      case 'up to 1 minute':
        return OneMinute();
      case '10 minutes':
        return TenMinutes();
      case '1 hour':
        return OneHour();
      case '8 hours':
        return EightHours();
      case '24 hours':
        return TwentyFourHours();
      case 'up to 10 minutes':
        return UpToTenMinutes();
      case 'up to 1 hour':
        return UpToOneHour();
      case 'up to 24 hours':
        return UpToTwentyFourHours();
      case '10 days':
        return TenDays();
      case 'until dispelled':
        return UntilDispelled();
      case 'special':
        return Special();
      case '1 minute':
        return OneMinuteExact();
      case '7 days':
        return SevenDays();
      case 'up to 8 hours':
        return UpToEightHours();
      case '30 days':
        return ThirtyDays();
      case 'until dispelled or triggered':
        return UntilDispelledOrTriggered();
      case 'up to 2 hours':
        return UpToTwoHours();
      case 'up to 1 round':
        return UpToOneRound();
      default:
        return SpellDurationCustom();
    }
  }

  bool compareTo(SpellDuration other) {
    final orderedByTime = [
      Instantaneous(),
      OneRound(),
      UpToOneRound(),
      OneMinuteExact(),
      OneMinute(),
      UpToTenMinutes(),
      TenMinutes(),
      UpToOneHour(),
      OneHour(),
      UpToTwoHours(),
      EightHours(),
      UpToEightHours(),
      TwentyFourHours(),
      UpToTwentyFourHours(),
      TenDays(),
      SevenDays(),
      ThirtyDays(),
      UntilDispelled(),
      UntilDispelledOrTriggered(),
      Special(),
    ];
    return orderedByTime.indexWhere((element) => element == this) <
        orderedByTime.indexWhere((element) => element == other);
  }

  static List<SpellDuration> get all => [
        Instantaneous(),
        OneRound(),
        OneMinute(),
        TenMinutes(),
        OneHour(),
        EightHours(),
        TwentyFourHours(),
        UpToTenMinutes(),
        UpToOneHour(),
        UpToTwentyFourHours(),
        TenDays(),
        UntilDispelled(),
        Special(),
        OneMinuteExact(),
        SevenDays(),
        UpToEightHours(),
        ThirtyDays(),
        UntilDispelledOrTriggered(),
        UpToTwoHours(),
        UpToOneRound(),
      ];
}

class Instantaneous extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Instantaneous';

  @override
  bool operator ==(Object other) {
    return other is Instantaneous;
  }

  @override
  int get hashCode => 1;
}

class OneRound extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '1 round';

  @override
  bool operator ==(Object other) {
    return other is OneRound;
  }

  @override
  int get hashCode => 2;
}

class OneMinute extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 1 minute';

  @override
  bool operator ==(Object other) {
    return other is OneMinute;
  }

  @override
  int get hashCode => 3;
}

class TenMinutes extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '10 minutes';

  @override
  bool operator ==(Object other) {
    return other is TenMinutes;
  }

  @override
  int get hashCode => 4;
}

class OneHour extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '1 hour';

  @override
  bool operator ==(Object other) {
    return other is OneHour;
  }

  @override
  int get hashCode => 5;
}

class EightHours extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '8 hours';

  @override
  bool operator ==(Object other) {
    return other is EightHours;
  }

  @override
  int get hashCode => 6;
}

class TwentyFourHours extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '24 hours';

  @override
  bool operator ==(Object other) {
    return other is TwentyFourHours;
  }

  @override
  int get hashCode => 7;
}

class UpToOneHour extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 1 hour';

  @override
  bool operator ==(Object other) {
    return other is UpToOneHour;
  }

  @override
  int get hashCode => 8;
}

class UpToTwentyFourHours extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 24 hours';

  @override
  bool operator ==(Object other) {
    return other is UpToTwentyFourHours;
  }

  @override
  int get hashCode => 9;
}

class TenDays extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '10 days';

  @override
  bool operator ==(Object other) {
    return other is TenDays;
  }

  @override
  int get hashCode => 10;
}

class UntilDispelled extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Until dispelled';

  @override
  bool operator ==(Object other) {
    return other is UntilDispelled;
  }

  @override
  int get hashCode => 11;
}

class Special extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Special';

  @override
  bool operator ==(Object other) {
    return other is Special;
  }

  @override
  int get hashCode => 12;
}

class OneMinuteExact extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '1 minute';

  @override
  bool operator ==(Object other) {
    return other is OneMinuteExact;
  }

  @override
  int get hashCode => 13;
}

class SevenDays extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '7 days';

  @override
  bool operator ==(Object other) {
    return other is SevenDays;
  }

  @override
  int get hashCode => 14;
}

class UpToEightHours extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 8 hours';

  @override
  bool operator ==(Object other) {
    return other is UpToEightHours;
  }

  @override
  int get hashCode => 15;
}

class ThirtyDays extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => '30 days';

  @override
  bool operator ==(Object other) {
    return other is ThirtyDays;
  }

  @override
  int get hashCode => 16;
}

class UntilDispelledOrTriggered extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Until dispelled or triggered';

  @override
  bool operator ==(Object other) {
    return other is UntilDispelledOrTriggered;
  }

  @override
  int get hashCode => 17;
}

class UpToTwoHours extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 2 hours';

  @override
  bool operator ==(Object other) {
    return other is UpToTwoHours;
  }

  @override
  int get hashCode => 18;
}

class UpToOneRound extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 1 round';

  @override
  bool operator ==(Object other) {
    return other is UpToOneRound;
  }

  @override
  int get hashCode => 19;
}

class UpToTenMinutes extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Up to 10 minutes';

  @override
  bool operator ==(Object other) {
    return other is UpToTenMinutes;
  }

  @override
  int get hashCode => 20;
}

// TODO: Implement custom duration
class SpellDurationCustom extends SpellDuration {
  @override
  get id => toString();

  @override
  toString() => 'Custom';
}
