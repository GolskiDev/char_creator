import 'package:char_creator/common/interfaces/identifiable.dart';

sealed class SpellRange implements Identifiable {
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
  get id => toString();
  
  @override
  String toString() => 'Self';

  @override
  bool operator ==(Object other) {
    return other is Self;
  }

  @override
  int get hashCode => 1;
}

class Touch extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => 'Touch';

  @override
  bool operator ==(Object other) {
    return other is Touch;
  }

  @override
  int get hashCode => 2;
}

class Sight extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => 'Sight';

  @override
  bool operator ==(Object other) {
    return other is Sight;
  }

  @override
  int get hashCode => 3;
}

class Unlimited extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => 'Unlimited';

  @override
  bool operator ==(Object other) {
    return other is Unlimited;
  }

  @override
  int get hashCode => 4;
}

class Feet30 extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => '30 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet30;
  }

  @override
  int get hashCode => 5;
}

class Feet60 extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => '60 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet60;
  }

  @override
  int get hashCode => 6;
}

class Feet120 extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => '120 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet120;
  }

  @override
  int get hashCode => 7;
}

class RangeCustom extends SpellRange {
  @override
  get id => toString();
  
  @override
  String toString() => 'Custom';
}
