sealed class SpellRange {
  static SpellRange fromString(String range) {
    switch (range) {
      case 'self':
        return Self();
      case 'touch':
        return Touch();
      case 'sight':
        return Sight();
      case 'unlimited':
        return Unlimited();
      case '30 feet':
        return Feet30();
      case '60 feet':
        return Feet60();
      case '120 feet':
        return Feet120();
      default:
        return RangeCustom();
    }
  }
}

class Self extends SpellRange {
  @override
  String toString() => 'Self';
}

class Touch extends SpellRange {
  @override
  String toString() => 'Touch';
}

class Sight extends SpellRange {
  @override
  String toString() => 'Sight';
}

class Unlimited extends SpellRange {
  @override
  String toString() => 'Unlimited';
}

class Feet30 extends SpellRange {
  @override
  String toString() => '30 feet';
}

class Feet60 extends SpellRange {
  @override
  String toString() => '60 feet';
}

class Feet120 extends SpellRange {
  @override
  String toString() => '120 feet';
}

//TODO: Implement custom range
class RangeCustom extends SpellRange {
  @override
  String toString() => 'Custom';
}
