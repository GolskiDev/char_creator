sealed class SpellSchool {
  const SpellSchool();

  factory SpellSchool.fromString(String schoolName) {
    switch (schoolName.toLowerCase()) {
      case 'abjuration':
        return Abjuration();
      case 'alteration':
        return Alteration();
      case 'evocation':
        return Evocation();
      case 'illusion':
        return Illusion();
      case 'necromancy':
        return Necromancy();
      case 'conjuration':
        return Conjuration();
      case 'divination':
        return Divination();
      case 'enchantment':
        return Enchantment();
      default:
        return Unknown();
    }
  }

  @override
  String toString() {
    switch (this) {
      case Abjuration():
        return 'abjuration';
      case Alteration():
        return 'alteration';
      case Evocation():
        return 'evocation';
      case Illusion():
        return 'illusion';
      case Necromancy():
        return 'necromancy';
      case Conjuration():
        return 'conjuration';
      case Divination():
        return 'divination';
      case Enchantment():
        return 'enchantment';
      case Unknown():
        return 'Unknown';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SpellSchool && other.runtimeType == runtimeType;
  }

  @override
  int get hashCode => runtimeType.hashCode;
}

extension SpellSchoolName on SpellSchool? {
  String get name {
    if (this == null) {
      return 'Unknown';
    }

    switch (this) {
      case Abjuration():
        return 'Abjuration';
      case Alteration():
        return 'Alteration';
      case Evocation():
        return 'Evocation';
      case Illusion():
        return 'Illusion';
      case Necromancy():
        return 'Necromancy';
      case Conjuration():
        return 'Conjuration';
      case Divination():
        return 'Divination';
      case Enchantment():
        return 'Enchantment';
      case Unknown():
        return 'Unknown';
      default:
        return 'Unknown';
    }
  }
}

class Abjuration extends SpellSchool {}

class Alteration extends SpellSchool {}

class Evocation extends SpellSchool {}

class Illusion extends SpellSchool {}

class Necromancy extends SpellSchool {}

class Conjuration extends SpellSchool {}

class Divination extends SpellSchool {}

class Enchantment extends SpellSchool {}

class Unknown extends SpellSchool {}
