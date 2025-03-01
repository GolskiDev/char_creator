sealed class SpellDuration {
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
  toString() => 'Instantaneous';
}

class OneRound extends SpellDuration {
  @override
  toString() => '1 round';
}

class OneMinute extends SpellDuration {
  @override
  toString() => 'Up to 1 minute';
}

class TenMinutes extends SpellDuration {
  @override
  toString() => '10 minutes';
}

class OneHour extends SpellDuration {
  @override
  toString() => '1 hour';
}

class EightHours extends SpellDuration {
  @override
  toString() => '8 hours';
}

class TwentyFourHours extends SpellDuration {
  @override
  toString() => '24 hours';
}

// TODO: Implement custom duration
class SpellDurationCustom extends SpellDuration {
  @override
  toString() => 'Custom';
}


