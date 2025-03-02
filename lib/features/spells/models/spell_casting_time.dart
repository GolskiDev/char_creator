import 'package:char_creator/common/interfaces/identifiable.dart';

sealed class SpellCastingTime implements Identifiable {
  static SpellCastingTime fromString(String castingTime) {
    switch (castingTime) {
      case '1 action':
        return OneAction();
      case '1 bonus action':
        return OneBonusAction();
      case '1 reaction':
        return OneReaction();
      case '1 minute':
        return OneMinute();
      case '10 minutes':
        return TenMinutes();
      case '1 hour':
        return OneHour();
      default:
        return SpellCastingTimeCustom();
    }
  }
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

class SpellCastingTimeCustom extends SpellCastingTime {
  @override
  get id => toString();
  
  @override
  toString() => 'Custom';
}
