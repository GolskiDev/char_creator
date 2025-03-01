sealed class SpellCastingTime {
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
  toString() => '1 action';
}

class OneBonusAction extends SpellCastingTime {
  @override
  toString() => '1 bonus action';
}

class OneReaction extends SpellCastingTime {
  @override
  toString() => '1 reaction';
}

class OneMinute extends SpellCastingTime {
  @override
  toString() => '1 minute';
}

class TenMinutes extends SpellCastingTime {
  @override
  toString() => '10 minutes';
}

class OneHour extends SpellCastingTime {
  @override
  toString() => '1 hour';
}

// TODO: Implement custom casting time
class SpellCastingTimeCustom extends SpellCastingTime {
  @override
  toString() => 'Custom';
}
