class SpellUtils {
  static String spellLevelString(int spellLevel) {
    switch (spellLevel) {
      case 0:
        return 'Cantrip';
      case 1:
        return '1st Level';
      case 2:
        return '2nd Level';
      case 3:
        return '3rd Level';
      default:
        return '${spellLevel}th Level';
    }
  }
}