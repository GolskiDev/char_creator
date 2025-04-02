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
      case '8 hours':
        return EightHours();
      case '1 reaction, which you take when you see a creature within 60 feet of you casting a spell':
        return ReactionToCreatureCastingSpell();
      case '24 hours':
        return TwentyFourHours();
      case '1 reaction, which you take in response to being damaged by a creature within 60 feet of you that you can see':
        return ReactionToBeingDamaged();
      case '12 hours':
        return TwelveHours();
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

class ReactionToCreatureCastingSpell extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() =>
      '1 reaction, which you take when you see a creature within 60 feet of you casting a spell';

  @override
  bool operator ==(Object other) {
    return other is ReactionToCreatureCastingSpell;
  }

  @override
  int get hashCode => 8;
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

class ReactionToBeingDamaged extends SpellCastingTime {
  @override
  get id => toString();

  @override
  toString() =>
      '1 reaction, which you take in response to being damaged by a creature within 60 feet of you that you can see';

  @override
  bool operator ==(Object other) {
    return other is ReactionToBeingDamaged;
  }

  @override
  int get hashCode => 10;
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
