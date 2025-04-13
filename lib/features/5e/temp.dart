class Item {
  String title = "Magical Hammer";
  ListOfPreparedSpells? listOfPreparedSpells;
}

abstract interface class MakesSpellReady {
  Set<String> get readySpellIds;
}

abstract interface class MakesSpellAvailable {
  Set<String> get availableSpellIds;
}

abstract interface class MakesSpellKnown {
  Set<String> get knownSpellIds;
}

class IntAdditionModifier implements IntModifier {
  @override
  int get modifier => _modifier;

  final String name;
  final int _modifier;

  IntAdditionModifier({
    required this.name,
    required int modifier,
  }) : _modifier = modifier;
}

abstract interface class IntModifier {
  int get modifier;
}

// abstract interface class IntMultiplicationModifier<IntValue> implements IntModifier{
//   int get multiplier;
// }

//Wizzard
class ListOfPreparedSpells implements MakesSpellReady {
  final Set<String> spellIds = {};

  @override
  Set<String> get readySpellIds => spellIds;
}

class CharacterClassModel {
  Map<int, dynamic> levelTraits = {
    1: {
      ListOfPreparedSpells(),
    }
  };
}

class Source {
  final Object source;
}

class IntValue {
  int get value => modifiers.fold(
        0,
        (previousValue, element) => previousValue + element.modifier,
      );

  final String name;
  final String id;
  final List<IntModifier> modifiers;
}
