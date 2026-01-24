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

final figherMD = '''
# Fighter

## Class Features

As a fighter, you gain the following class features.

#### Hit Points

**Hit** **Dice:** 1d10 per fighter level

**Hit** **Points** **at** **1st** **Level:** 10 + your Constitution modifier

**Hit Points at Higher Levels:** 1d10 (or 6) + your Constitution modifier per fighter level after 1st

#### Proficiencies

**Armor:** All armor, shields

**Weapons:** Simple weapons, martial weapons

**Tools:** None

**Saving** **Throws:** Strength, Constitution

**Skills:** Choose two skills from Acrobatics, Animal Handling, Athletics, History, Insight, Intimidation, Perception, and Survival

#### Equipment

You start with the following equipment, in addition to the equipment granted by your background:

-   (_a_) chain mail or (_b_) leather armor, longbow, and 20 arrows
    
-   (_a_) a martial weapon and a shield or (_b_) two martial weapons
    
-   (_a_) a light crossbow and 20 bolts or (_b_) two handaxes
    
-   (_a_) a dungeoneer’s pack or (_b_) an explorer’s pack
    

  

**The** **Fighter**

**Proficiency**

  

  

16th

+5

Ability Score Improvement

17th

+6

Action Surge (two uses),

Indomitable (three uses)

18th

+6

Martial Archetype feature

19th

+6

Ability Score Improvement

20th

+6

Extra Attack (3)

  

### Fighting Style

  

![Shape55](SRD_CC_v5.1_libre_html_f6d80012.gif)

You adopt a particular style of fighting as your specialty. Choose one of the following options. You can’t take a Fighting Style option more than once, even if you later get to choose again.

#### Archery

You gain a +2 bonus to attack rolls you make with ranged weapons.

#### Defense

While you are wearing armor, you gain a +1 bonus to AC.

#### Dueling

When you are wielding a melee weapon in one hand and no other weapons, you gain a +2 bonus to damage rolls with that weapon.

#### Great Weapon Fighting

When you roll a 1 or 2 on a damage die for an attack you make with a melee weapon that you are wielding with two hands, you can reroll the die and must use the new roll, even if the new roll is a 1 or a

2. The weapon must have the two-­‐‑handed or versatile property for you to gain this benefit.

#### Protection

When a creature you can see attacks a target other than you that is within 5 feet of you, you can use

**Level**

**Bonus** **Features**

your reaction to impose disadvantage on the attack roll. You must be wielding a shield.

![Textbox 163](SRD_CC_v5.1_libre_html_56932f2b.gif)

3rd +2 Martial Archetype

![Textbox 164](SRD_CC_v5.1_libre_html_56932f2b.gif)

1st +2 Fighting Style, Second Wind

2nd +2 Action Surge (one use)

  

![Textbox 165](SRD_CC_v5.1_libre_html_56932f2b.gif)

15th +5 Martial Archetype feature

![Textbox 166](SRD_CC_v5.1_libre_html_56932f2b.gif)

13th +5 Indomitable (two uses)

![Textbox 167](SRD_CC_v5.1_libre_html_56932f2b.gif)

11th +4 Extra Attack (2)

![Textbox 168](SRD_CC_v5.1_libre_html_d3c952f4.gif)

9th +4 Indomitable (one use)

![Textbox 169](SRD_CC_v5.1_libre_html_56932f2b.gif)

7th +3 Martial Archetype feature

![Textbox 170](SRD_CC_v5.1_libre_html_d3c952f4.gif)

5th +3 Extra Attack

4th +2 Ability Score Improvement 6th +3 Ability Score Improvement 8th +3 Ability Score Improvement 10th +4 Martial Archetype feature 12th +4 Ability Score Improvement 14th +5 Ability Score Improvement

#### Two-Weapon Fighting

When you engage in two-­‐‑weapon fighting, you can add your ability modifier to the damage of the second attack.

### Second Wind

  

![Shape56](SRD_CC_v5.1_libre_html_f6d80012.gif)

You have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level. Once you use this feature, you must finish a short or long rest before you can use it again.

### Action Surge

  

![Shape57](SRD_CC_v5.1_libre_html_f6d80012.gif)

Starting at 2nd level, you can push yourself beyond your normal limits for a moment. On your turn, you can take one additional action on top of your regular action and a possible bonus action.

Once you use this feature, you must finish a short or long rest before you can use it again. Starting at 17th level, you can use it twice before a rest, but only once on the same turn.

### Martial Archetype

  

![Shape58](SRD_CC_v5.1_libre_html_f6d80012.gif)

At 3rd level, you choose an archetype that you strive to emulate in your combat styles and techniques, such as Champion. The archetype you choose grants you features at 3rd level and again at 7th, 10th, 15th, and 18th level.

### Ability Score Improvement

  

![Shape59](SRD_CC_v5.1_libre_html_f6d80012.gif)

When you reach 4th level, and again at 6th, 8th, 12th, 14th, 16th, and 19th level, you can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal,

you can’t increase an ability score above 20 using this feature.

**Extra** **Attack**

Beginning at 5th level, you can attack twice, instead of once, whenever you take the Attack action on your turn.

The number of attacks increases to three when you reach 11th level in this class and to four when you reach 20th level in this class.

### Indomitable

  

![Shape60](SRD_CC_v5.1_libre_html_f6d80012.gif)

Beginning at 9th level, you can reroll a saving throw that you fail. If you do so, you must use the new roll, and you can’t use this feature again until you finish a long rest.

You can use this feature twice between long rests starting at 13th level and three times between long rests starting at 17th level.

  

## Martial Archetypes

Different fighters choose different approaches to perfecting their fighting prowess. The martial archetype you choose to emulate reflects your approach.

### Champion

The archetypal Champion focuses on the development of raw physical power honed to deadly perfection. Those who model themselves on this archetype combine rigorous training with physical excellence to deal devastating blows.

#### Improved Critical

Beginning when you choose this archetype at 3rd level, your weapon attacks score a critical hit on a roll of 19 or 20.

#### Remarkable Athlete

Starting at 7th level, you can add half your proficiency bonus (round up) to any Strength, Dexterity, or Constitution check you make that doesn’t already use your proficiency bonus.

In addition, when you make a running long jump, the distance you can cover increases by a number of feet equal to your Strength modifier.

#### Additional Fighting Style

At 10th level, you can choose a second option from the Fighting Style class feature.

#### Superior Critical

Starting at 15th level, your weapon attacks score a critical hit on a roll of 18–20.

#### Survivor

At 18th level, you attain the pinnacle of resilience in battle. At the start of each of your turns, you regain hit points equal to 5 + your Constitution modifier if you have no more than half of your hit points left.

You don’t gain this benefit if you have 0 hit points.
''';

final fighter = {
  "id": "fighter_001",
  "title": "Fighter",
  "description": "As a fighter, you gain the following class features.",
  "traits": [
    {
      "id": "hit_dice_fighter_001",
      "title": "Hit Dice",
      "description": "1d10 per fighter level",
      "showUnder": ["character.hitDice"]
    },
    {
      "id": "hit_points_1st_level_fighter_002",
      "title": "Hit Points at 1st Level",
      "description": "10 + your Constitution modifier",
      "showUnder": ["character.hitPoints"]
    },
    {
      "id": "hit_points_higher_levels_fighter_003",
      "title": "Hit Points at Higher Levels",
      "description":
          "1d10 (or 6) + your Constitution modifier per fighter level after 1st",
      "showUnder": ["character.hitPoints"]
    },
    {
      "id": "proficiencies_armor_fighter_004",
      "title": "Armor Proficiencies",
      "description": "All armor, shields",
      "showUnder": ["character.proficiencies.armor"]
    },
    {
      "id": "proficiencies_weapons_fighter_005",
      "title": "Weapon Proficiencies",
      "description": "Simple weapons, martial weapons",
      "showUnder": ["character.proficiencies.weapons"]
    },
    {
      "id": "saving_throws_fighter_007",
      "title": "Saving Throws",
      "description": "Strength, Constitution",
      "showUnder": [
        "character.savingThrows.strength",
        "character.savingThrows.constitution"
      ]
    },
    {
      "id": "skills_fighter_008",
      "title": "Skills",
      "description":
          "Choose two skills from Acrobatics, Animal Handling, Athletics, History, Insight, Intimidation, Perception, and Survival",
      "showUnder": ["character.skills"]
    },
    {
      "id": "equipment_fighter_009",
      "title": "Equipment",
      "description":
          "You start with the following equipment, in addition to the equipment granted by your background:\n- (a) chain mail or (b) leather armor, longbow, and 20 arrows\n- (a) a martial weapon and a shield or (b) two martial weapons\n- (a) a light crossbow and 20 bolts or (b) two handaxes\n- (a) a dungeoneer’s pack or (b) an explorer’s pack",
      "showUnder": ["character.equipment"]
    },
    {
      "id": "fighting_style_fighter_010",
      "title": "Fighting Style",
      "description":
          "You adopt a particular style of fighting as your specialty. Choose one of the following options. You can’t take a Fighting Style option more than once, even if you later get to choose again.",
      "showUnder": ["character.features"]
    },
    {
      "id": "archery_fighter_011",
      "title": "Archery",
      "description":
          "You gain a +2 bonus to attack rolls you make with ranged weapons.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "defense_fighter_012",
      "title": "Defense",
      "description": "While you are wearing armor, you gain a +1 bonus to AC.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "dueling_fighter_013",
      "title": "Dueling",
      "description":
          "When you are wielding a melee weapon in one hand and no other weapons, you gain a +2 bonus to damage rolls with that weapon.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "great_weapon_fighting_fighter_014",
      "title": "Great Weapon Fighting",
      "description":
          "When you roll a 1 or 2 on a damage die for an attack you make with a melee weapon that you are wielding with two hands, you can reroll the die and must use the new roll, even if the new roll is a 1 or a 2. The weapon must have the two-handed or versatile property for you to gain this benefit.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "protection_fighter_015",
      "title": "Protection",
      "description":
          "When a creature you can see attacks a target other than you that is within 5 feet of you, you can use your reaction to impose disadvantage on the attack roll. You must be wielding a shield.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "two_weapon_fighting_fighter_016",
      "title": "Two-Weapon Fighting",
      "description":
          "When you engage in two-weapon fighting, you can add your ability modifier to the damage of the second attack.",
      "showUnder": ["character.features.fightingStyle"]
    },
    {
      "id": "second_wind_fighter_017",
      "title": "Second Wind",
      "description":
          "You have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level. Once you use this feature, you must finish a short or long rest before you can use it again.",
      "showUnder": ["character.features"]
    },
    {
      "id": "action_surge_fighter_018",
      "title": "Action Surge",
      "description":
          "Starting at 2nd level, you can push yourself beyond your normal limits for a moment. On your turn, you can take one additional action on top of your regular action and a possible bonus action. Once you use this feature, you must finish a short or long rest before you can use it again. Starting at 17th level, you can use it twice before a rest, but only once on the same turn.",
      "showUnder": ["character.features"]
    },
    {
      "id": "martial_archetype_fighter_019",
      "title": "Martial Archetype",
      "description":
          "At 3rd level, you choose an archetype that you strive to emulate in your combat styles and techniques, such as Champion. The archetype you choose grants you features at 3rd level and again at 7th, 10th, 15th, and 18th level.",
      "showUnder": ["character.features"]
    },
    {
      "id": "ability_score_improvement_fighter_020",
      "title": "Ability Score Improvement",
      "description":
          "When you reach 4th level, and again at 6th, 8th, 12th, 14th, 16th, and 19th level, you can increase one ability score of your choice by 2, or you can increase two ability scores of your choice by 1. As normal, you can’t increase an ability score above 20 using this feature.",
      "showUnder": ["character.abilityScores"]
    },
    {
      "id": "extra_attack_fighter_021",
      "title": "Extra Attack",
      "description":
          "Beginning at 5th level, you can attack twice, instead of once, whenever you take the Attack action on your turn. The number of attacks increases to three when you reach 11th level in this class and to four when you reach 20th level in this class.",
      "showUnder": ["character.features"]
    },
    {
      "id": "indomitable_fighter_022",
      "title": "Indomitable",
      "description":
          "Beginning at 9th level, you can reroll a saving throw that you fail. If you do so, you must use the new roll, and you can’t use this feature again until you finish a long rest. You can use this feature twice between long rests starting at 13th level and three times between long rests starting at 17th level.",
      "showUnder": ["character.features"]
    },
    {
      "id": "champion_archetype_fighter_023",
      "title": "Champion Archetype",
      "description":
          "The archetypal Champion focuses on the development of raw physical power honed to deadly perfection. Those who model themselves on this archetype combine rigorous training with physical excellence to deal devastating blows.",
      "showUnder": ["character.archetype"]
    },
    {
      "id": "improved_critical_champion_024",
      "title": "Improved Critical",
      "description":
          "Beginning when you choose this archetype at 3rd level, your weapon attacks score a critical hit on a roll of 19 or 20.",
      "showUnder": ["character.archetype.features"]
    },
    {
      "id": "remarkable_athlete_champion_025",
      "title": "Remarkable Athlete",
      "description":
          "Starting at 7th level, you can add half your proficiency bonus (round up) to any Strength, Dexterity, or Constitution check you make that doesn’t already use your proficiency bonus. In addition, when you make a running long jump, the distance you can cover increases by a number of feet equal to your Strength modifier.",
      "showUnder": ["character.archetype.features"]
    },
    {
      "id": "additional_fighting_style_champion_026",
      "title": "Additional Fighting Style",
      "description":
          "At 10th level, you can choose a second option from the Fighting Style class feature.",
      "showUnder": ["character.archetype.features"]
    },
    {
      "id": "superior_critical_champion_027",
      "title": "Superior Critical",
      "description":
          "Starting at 15th level, your weapon attacks score a critical hit on a roll of 18–20.",
      "showUnder": ["character.archetype.features"]
    },
    {
      "id": "survivor_champion_028",
      "title": "Survivor",
      "description":
          "At 18th level, you attain the pinnacle of resilience in battle. At the start of each of your turns, you regain hit points equal to 5 + your Constitution modifier if you have no more than half of your hit points left. You don’t gain this benefit if you have 0 hit points.",
      "showUnder": ["character.archetype.features"]
    }
  ]
};
