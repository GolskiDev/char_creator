import 'package:spells_and_tools/common/interfaces/identifiable.dart';

sealed class SpellRange implements Identifiable {
  static SpellRange fromString(String range) {
    switch (range.toLowerCase()) {
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
      case '10 feet':
        return Feet10();
      case '150 feet':
        return Feet150();
      case '1 mile':
        return Mile1();
      case '300 feet':
        return Feet300();
      case '500 feet':
        return Feet500();
      case 'Special':
        return Special();
      case '100 feet':
        return Feet100();
      case '500 miles':
        return Miles500();
      case '5 feet':
        return Feet5();
      default:
        return RangeCustom();
    }
  }

  int compareTo(SpellRange other) {
    final orderedRanges = [
      RangeCustom(),
      Self(),
      Touch(),
      Sight(),
      Unlimited(),
      Feet30(),
      Feet60(),
      Feet120(),
      Feet10(),
      Feet150(),
      Mile1(),
      Feet300(),
      Feet500(),
      Special(),
      Feet100(),
      Miles500(),
      Feet5(),
    ];

    return orderedRanges.indexWhere((d) => d == this) -
        orderedRanges.indexWhere((d) => d == other);
  }

  static List<SpellRange> get all => [
        RangeCustom(),
        Self(),
        Touch(),
        Sight(),
        Unlimited(),
        Feet30(),
        Feet60(),
        Feet120(),
        Feet10(),
        Feet150(),
        Mile1(),
        Feet300(),
        Feet500(),
        Special(),
        Feet100(),
        Miles500(),
        Feet5(),
      ];
}

class RangeCustom extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => 'Custom';

  @override
  bool operator ==(Object other) {
    return other is RangeCustom;
  }

  @override
  int get hashCode => 0;
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

class Feet10 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '10 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet10;
  }

  @override
  int get hashCode => 8;
}

class Feet150 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '150 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet150;
  }

  @override
  int get hashCode => 9;
}

class Mile1 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '1 mile';

  @override
  bool operator ==(Object other) {
    return other is Mile1;
  }

  @override
  int get hashCode => 10;
}

class Feet300 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '300 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet300;
  }

  @override
  int get hashCode => 11;
}

class Feet500 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '500 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet500;
  }

  @override
  int get hashCode => 12;
}

class Special extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => 'Special';

  @override
  bool operator ==(Object other) {
    return other is Special;
  }

  @override
  int get hashCode => 13;
}

class Feet100 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '100 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet100;
  }

  @override
  int get hashCode => 14;
}

class Miles500 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '500 miles';

  @override
  bool operator ==(Object other) {
    return other is Miles500;
  }

  @override
  int get hashCode => 15;
}

class Feet5 extends SpellRange {
  @override
  get id => toString();

  @override
  String toString() => '5 feet';

  @override
  bool operator ==(Object other) {
    return other is Feet5;
  }

  @override
  int get hashCode => 16;
}
