import 'package:char_creator/common/interfaces/identifiable.dart';

sealed class SpellDuration implements Identifiable{
  static SpellDuration fromString(String duration) {
    switch (duration) {
      case 'Instantaneous':
        return Instantaneous();
      case '1 round':
        return OneRound();
      case 'Up to 1 minute':
        return OneMinute();
      case '10 minutes':
        return TenMinutes();
      case '1 hour':
        return OneHour();
      case '8 hours':
        return EightHours();
      case '24 hours':
        return TwentyFourHours();
      default:
        return SpellDurationCustom();
    }
  }
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

// TODO: Implement custom duration
class SpellDurationCustom extends SpellDuration {
  @override
  get id => toString();
  
  @override
  toString() => 'Custom';
}


