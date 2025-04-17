import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameSystemViewModel {
  static final strength = GameSystemViewModelItem(
    name: 'Strength',
    icon: Icons.fitness_center,
  );
  static final dexterity = GameSystemViewModelItem(
    name: 'Dexterity',
    icon: Icons.directions_run,
  );
  static final constitution = GameSystemViewModelItem(
    name: 'Constitution',
    icon: Icons.health_and_safety,
  );
  static final intelligence = GameSystemViewModelItem(
    name: 'Intelligence',
    icon: Icons.psychology,
  );
  static final wisdom = GameSystemViewModelItem(
    name: 'Wisdom',
    icon: Icons.lightbulb,
  );
  static final charisma = GameSystemViewModelItem(
    name: 'Charisma',
    icon: Icons.star,
  );
  static final armorClass = GameSystemViewModelItem(
    name: 'Armor Class',
    icon: Icons.shield,
  );
  static final initiative = GameSystemViewModelItem(
    name: 'Initiative',
    icon: Icons.flash_on,
  );
  static final speed = GameSystemViewModelItem(
    name: 'Speed',
    icon: Symbols.directions_walk,
  );
  static final proficiencyBonus = GameSystemViewModelItem(
    name: 'Proficiency Bonus',
    icon: Icons.add_circle,
  );
  static final hitPoints = GameSystemViewModelItem(
    name: 'Hit Points',
    icon: Icons.favorite,
  );
  static final savingThrows = GameSystemViewModelItem(
    name: 'Saving Throws',
    icon: Icons.security,
  );

  // Additional items based on SpellFilterDrawer and CardWidget
  static final spellLevel = GameSystemViewModelItem(
    name: 'Spell Level',
    icon: Icons.star,
  );
  static final castingTime = GameSystemViewModelItem(
    name: 'Casting Time',
    icon: Icons.timer,
  );
  static final range = GameSystemViewModelItem(
    name: 'Range',
    icon: Symbols.swap_calls,
  );
  static final duration = GameSystemViewModelItem(
    name: 'Duration',
    icon: Icons.timelapse,
  );
  static final concentration = GameSystemViewModelItem(
    name: 'Requires Concentration',
    icon: Symbols.mindfulness,
  );
  static final ritual = GameSystemViewModelItem(
    name: 'Can Be Cast As Ritual',
    icon: Symbols.person_celebrate,
  );
  static final verbalComponent = GameSystemViewModelItem(
    name: 'Verbal Component',
    icon: Icons.record_voice_over,
  );
  static final somaticComponent = GameSystemViewModelItem(
    name: 'Somatic Component',
    icon: Icons.waving_hand,
  );
  static final materialComponent = GameSystemViewModelItem(
    name: 'Material Component',
    icon: Icons.category,
  );
  static final school = GameSystemViewModelItem(
    name: 'School',
    icon: Icons.book,
  );
  static final spellType = GameSystemViewModelItem(
    name: 'Spell Type',
    icon: Symbols.emoji_symbols,
  );
  static final characterClass = GameSystemViewModelItem(
    name: 'Class',
    icon: Symbols.identity_platform,
  );

  // New items based on additional filters and traits
  static final character = GameSystemViewModelItem(
    name: 'Character',
    icon: Symbols.person,
  );
}

class GameSystemViewModelItem {
  final String name;
  final String? link;
  final IconData? icon;

  GameSystemViewModelItem({
    required this.name,
    this.link,
    this.icon,
  });
}

abstract interface class IGameSystemViewModelItem {
  String get name;
  String? get link;
  IconData? get icon;
}
