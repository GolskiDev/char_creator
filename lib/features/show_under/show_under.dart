import 'package:flutter/material.dart';

import 'trait_model.dart';

/// ShowUnder is a system, where you have some Data and would like to present it under another target widget.
/// The target widget has it's name.

abstract interface class ShowUnderTarget {
  String get targetName;
}

final data = {
  "title": "Hello World",
  "description": "This is a description",
  "imageUrl": "https://example.com/image.png",
  "items": [
    {
      "title": "Item 1",
      "description": "This is item 1",
      "showUnder": "character.details",
    },
    {
      "title": "Item 2",
      "description": "This is item 2",
      "showUnder": "character.someOtherPlace",
    },
    {
      "title": "Item 3",
      "description": "This is item 3",
      "showUnder": "character.details",
    }
  ],
};

class ShowUnderDataProvider extends InheritedWidget {
  const ShowUnderDataProvider({
    required this.data,
    required super.child,
    super.key,
  });

  final List<TraitModel> data;

  List<TraitModel> dataForTarget(String targetName) {
    return data.where((item) => item.showUnder.contains(targetName)).toList();
  }

  static ShowUnderDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShowUnderDataProvider>();
  }

  @override
  bool updateShouldNotify(covariant ShowUnderDataProvider oldWidget) {
    return oldWidget.data != data;
  }
}

final dwarfRaceMD = """
## Dwarf

### Dwarf Traits

![Shape2](SRD_CC_v5.1_libre_html_f6d80012.gif)

Your dwarf character has an assortment of inborn abilities, part and parcel of dwarven nature.

_**Ability**_ _**Score**_ _**Increase.**_ Your Constitution score increases by 2.

_**Age.**_ Dwarves mature at the same rate as humans, but they’re considered young until they reach the age of 50. On average, they live about 350 years.

_**Alignment.**_ Most dwarves are lawful, believing firmly in the benefits of a well-­‐‑ordered society. They tend toward good as well, with a strong sense of fair play and a belief that everyone deserves to share in the benefits of a just order.

_**Size.**_ Dwarves stand between 4 and 5 feet tall and average about 150 pounds. Your size is Medium.

_**Speed.**_ Your base walking speed is 25 feet. Your speed is not reduced by wearing heavy armor.

_**Darkvision.**_ Accustomed to life underground, you have superior vision in dark and dim conditions. You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.

You can’t discern color in darkness, only shades of gray.

_**Dwarven**_ _**Resilience.**_ You have advantage on saving throws against poison, and you have resistance against poison damage.

_**Dwarven**_ _**Combat**_ _**Training.**_ You have proficiency with the battleaxe, handaxe, light hammer, and warhammer.

_**Tool Proficiency.**_ You gain proficiency with the artisan’s tools of your choice: smith’s tools, brewer’s supplies, or mason’s tools.

_**Stonecunning.**_ Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient in the History skill and add double your proficiency bonus to the check, instead of your normal proficiency bonus.

_**Languages.**_ You can speak, read, and write Common and Dwarvish. Dwarvish is full of hard consonants and guttural sounds, and those characteristics spill over into whatever other language a dwarf might speak.

#### Hill Dwarf

As a hill dwarf, you have keen senses, deep intuition, and remarkable resilience.

_**Ability**_ _**Score**_ _**Increase.**_ Your Wisdom score increases by 1.

_**Dwarven Toughness.**_ Your hit point maximum increases by 1, and it increases by 1 every time you gain a level.
""";

final dwarf = {
  "id": "dwarf_001",
  "title": "Dwarf",
  "description":
      "Your dwarf character has an assortment of inborn abilities, part and parcel of dwarven nature.",
  "traits": [
    {
      "id": "ability_score_increase_dwarf_001",
      "title": "Ability Score Increase",
      "description": "Your Constitution score increases by 2.",
      "showUnder": ["character.abilityScores.constitution"]
    },
    {
      "id": "age_dwarf_002",
      "title": "Age",
      "description":
          "Dwarves mature at the same rate as humans, but they’re considered young until they reach the age of 50. On average, they live about 350 years.",
      "showUnder": ["character.age"],
    },
    {
      "id": "alignment_dwarf_003",
      "title": "Alignment",
      "description":
          "Most dwarves are lawful, believing firmly in the benefits of a well-­‐‑ordered society. They tend toward good as well, with a strong sense of fair play and a belief that everyone deserves to share in the benefits of a just order.",
      "showUnder": ["character.alignment"],
    },
    {
      "id": "size_dwarf_004",
      "title": "Size",
      "description":
          "Dwarves stand between 4 and 5 feet tall and average about 150 pounds. Your size is Medium.",
      "showUnder": ["character.size"],
    },
    {
      "id": "speed_dwarf_005",
      "title": "Speed",
      "description":
          "Your base walking speed is 25 feet. Your speed is not reduced by wearing heavy armor.",
      "showUnder": ["character.speed"],
    },
    {
      "id": "darkvision_dwarf_006",
      "title": "Darkvision",
      "description":
          "Accustomed to life underground, you have superior vision in dark and dim conditions. You can see in dim light within 60 feet of you as if it were bright light, and in darkness as if it were dim light.",
      "showUnder": ["character.vision"],
    },
    {
      "id": "dwarven_resilience_dwarf_007",
      "title": "Dwarven Resilience",
      "description":
          "You have advantage on saving throws against poison, and you have resistance against poison damage.",
      "showUnder": ["character.resistances", "character.savingThrows"],
    },
    {
      "id": "dwarven_combat_training_dwarf_008",
      "title": "Dwarven Combat Training",
      "description":
          "You have proficiency with the battleaxe, handaxe, light hammer, and warhammer.",
      "showUnder": ["character.proficiencies", "character.weapons"],
    },
    {
      "id": "tool_proficiency_dwarf_009",
      "title": "Tool Proficiency",
      "description":
          "You gain proficiency with the artisan’s tools of your choice: smith’s tools, brewer’s supplies, or mason’s tools.",
      "showUnder": ["character.proficiencies", "character.tools"],
    },
    {
      "id": "stonecunning_dwarf_010",
      "title": "Stonecunning",
      "description":
          "Whenever you make an Intelligence (History) check related to the origin of stonework, you are considered proficient in the History skill and add double your proficiency bonus to the check, instead of your normal proficiency bonus.",
      "showUnder": ["character.skills.history"],
    },
    {
      "id": "languages_dwarf_011",
      "title": "Languages",
      "description":
          "You can speak, read, and write Common and Dwarvish. Dwarvish is full of hard consonants and guttural sounds, and those characteristics spill over into whatever other language a dwarf might speak.",
      "showUnder": ["character.languages"],
    },
  ],
};

final hillDwarf = {
  "id": "hill_dwarf_002",
  "title": "Hill Dwarf",
  "description":
      "As a hill dwarf, you have keen senses, deep intuition, and remarkable resilience.",
  "traits": [
    {
      "id": "ability_score_increase_hill_dwarf_001",
      "title": "Ability Score Increase",
      "description": "Your Wisdom score increases by 1.",
      "showUnder": ["character.abilityScores", "character.wisdom"]
    },
    {
      "id": "dwarven_toughness_hill_dwarf_002",
      "title": "Dwarven Toughness",
      "description":
          "Your hit point maximum increases by 1, and it increases by 1 every time you gain a level.",
      "showUnder": ["character.hitPoints"],
    },
  ],
};
