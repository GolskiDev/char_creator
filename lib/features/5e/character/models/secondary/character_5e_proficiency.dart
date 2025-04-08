class ICharacter5eProficiency {
  int get proficiencyBonus => 0;
}

class Character5eProficiencyFromCharacterLevel
    implements ICharacter5eProficiency {
  final int _characterLevel;

  @override
  int get proficiencyBonus {
    if (_characterLevel < 5) {
      return 2;
    } else if (_characterLevel < 9) {
      return 3;
    } else if (_characterLevel < 13) {
      return 4;
    } else if (_characterLevel < 17) {
      return 5;
    } else {
      return 6;
    }
  }

  Character5eProficiencyFromCharacterLevel({
    required int characterLevel,
  }) : _characterLevel = characterLevel;

  @override
  String toString() {
    return 'Character5eProficiency(proficiencyBonus: $proficiencyBonus)';
  }
}

class Character5eProficiencyCustom implements ICharacter5eProficiency {
  final int _proficiencyBonus;

  @override
  int get proficiencyBonus => _proficiencyBonus;

  Character5eProficiencyCustom({
    required int proficiencyBonus,
  }) : _proficiencyBonus = proficiencyBonus;

  @override
  String toString() {
    return 'Character5eProficiency(proficiencyBonus: $proficiencyBonus)';
  }
}
