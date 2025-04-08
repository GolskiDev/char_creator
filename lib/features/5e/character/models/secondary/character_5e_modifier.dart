class ICharacter5eModifier {
  int get modifier => 0;
}

class Character5eModifierFromAbilityScore implements ICharacter5eModifier {
  final int _abilityScore;

  @override
  int get modifier => (_abilityScore - 10) ~/ 2;

  Character5eModifierFromAbilityScore({
    required int abilityScore,
  }) : _abilityScore = abilityScore;
}

class Character5eModifierCustom implements ICharacter5eModifier {
  final int _modifier;

  @override
  int get modifier => _modifier;

  Character5eModifierCustom({
    required int modifier,
  }) : _modifier = modifier;
}
