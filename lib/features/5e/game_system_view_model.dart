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
    icon: Icons.health_and_safety_outlined,
  );
  static final intelligence = GameSystemViewModelItem(
    name: 'Intelligence',
    icon: Icons.psychology_outlined,
  );
  static final wisdom = GameSystemViewModelItem(
    name: 'Wisdom',
    icon: Icons.lightbulb_outline,
  );
  static final charisma = GameSystemViewModelItem(
    name: 'Charisma',
    icon: Symbols.sentiment_very_satisfied,
  );

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

  static final character = GameSystemViewModelItem(
    name: 'Character',
    icon: Symbols.person,
  );

  static final spells = GameSystemViewModelItem(
    name: 'Spells',
    icon: Symbols.magic_button,
  );

  static final abilityScores = GameSystemViewModelItem(
    name: 'Ability Scores',
    icon: Icons.bar_chart,
  );

  static final modifier = GameSystemViewModelItem(
    name: 'Modifier',
    icon: Icons.add_circle_outline,
  );

  static final savingThrowModifier = GameSystemViewModelItem(
    name: 'Saving Throw',
    icon: Icons.security,
  );

  static final skills = GameSystemViewModelItem(
    name: 'Skills',
    icon: Symbols.emoji_objects,
  );

  static final athletics = GameSystemViewModelItem(
    name: 'Athletics',
    icon: Symbols.sports_gymnastics,
  );
  static final acrobatics = GameSystemViewModelItem(
    name: 'Acrobatics',
    icon: Symbols.sports_kabaddi,
  );
  static final sleightOfHand = GameSystemViewModelItem(
    name: 'Sleight of Hand',
    icon: Symbols.handshake,
  );
  static final stealth = GameSystemViewModelItem(
    name: 'Stealth',
    icon: Symbols.visibility_off,
  );
  static final arcana = GameSystemViewModelItem(
    name: 'Arcana',
    icon: Symbols.auto_awesome,
  );
  static final history = GameSystemViewModelItem(
    name: 'History',
    icon: Symbols.history_edu,
  );
  static final investigation = GameSystemViewModelItem(
    name: 'Investigation',
    icon: Symbols.search,
  );
  static final nature = GameSystemViewModelItem(
    name: 'Nature',
    icon: Symbols.park,
  );
  static final religion = GameSystemViewModelItem(
    name: 'Religion',
    icon: Symbols.temple_hindu,
  );
  static final animalHandling = GameSystemViewModelItem(
    name: 'Animal Handling',
    icon: Symbols.pets,
  );
  static final insight = GameSystemViewModelItem(
    name: 'Insight',
    icon: Symbols.lightbulb,
  );
  static final medicine = GameSystemViewModelItem(
    name: 'Medicine',
    icon: Symbols.medical_services,
  );
  static final perception = GameSystemViewModelItem(
    name: 'Perception',
    icon: Symbols.visibility,
  );
  static final survival = GameSystemViewModelItem(
    name: 'Survival',
    icon: Symbols.camping,
  );
  static final deception = GameSystemViewModelItem(
    name: 'Deception',
    icon: Symbols.mood_bad,
  );
  static final intimidation = GameSystemViewModelItem(
    name: 'Intimidation',
    icon: Symbols.warning,
  );
  static final performance = GameSystemViewModelItem(
    name: 'Performance',
    icon: Symbols.theater_comedy,
  );
  static final persuasion = GameSystemViewModelItem(
    name: 'Persuasion',
    icon: Symbols.thumb_up,
  );

  static final conditions = GameSystemViewModelItem(
    name: 'Conditions',
    icon: Symbols.warning_amber,
  );

  static final blinded = GameSystemViewModelItem(
    name: 'Blinded',
    icon: Symbols.visibility_off,
  );
  static final charmed = GameSystemViewModelItem(
    name: 'Charmed',
    icon: Symbols.favorite,
  );
  static final deafened = GameSystemViewModelItem(
    name: 'Deafened',
    icon: Symbols.hearing_disabled,
  );
  static final frightened = GameSystemViewModelItem(
    name: 'Frightened',
    icon: Symbols.warning,
  );
  static final grappled = GameSystemViewModelItem(
    name: 'Grappled',
    icon: Symbols.sports_mma,
  );
  static final incapacitated = GameSystemViewModelItem(
    name: 'Incapacitated',
    icon: Symbols.bed,
  );
  static final invisible = GameSystemViewModelItem(
    name: 'Invisible',
    icon: Symbols.visibility,
  );
  static final paralyzed = GameSystemViewModelItem(
    name: 'Paralyzed',
    icon: Symbols.accessibility_new,
  );
  static final petrified = GameSystemViewModelItem(
    name: 'Petrified',
    icon: Icons.terrain,
  );
  static final poisoned = GameSystemViewModelItem(
    name: 'Poisoned',
    icon: Symbols.science,
  );
  static final prone = GameSystemViewModelItem(
    name: 'Prone',
    icon: Symbols.airline_seat_flat,
  );
  static final restrained = GameSystemViewModelItem(
    name: 'Restrained',
    icon: Symbols.lock,
  );
  static final stunned = GameSystemViewModelItem(
    name: 'Stunned',
    icon: Symbols.flash_on,
  );
  static final unconscious = GameSystemViewModelItem(
    name: 'Unconscious',
    icon: Symbols.hotel,
  );

  static final exhaustionLevel0 = GameSystemViewModelItem(
    name: 'No Exhaustion',
    icon: Symbols.sentiment_very_satisfied,
  );
  static final exhaustionLevel1 = GameSystemViewModelItem(
    name: 'Exhaustion Level 1',
    icon: Symbols.directions_walk,
  );
  static final exhaustionLevel2 = GameSystemViewModelItem(
    name: 'Exhaustion Level 2',
    icon: Symbols.stairs,
  );
  static final exhaustionLevel3 = GameSystemViewModelItem(
    name: 'Exhaustion Level 3',
    icon: Symbols.airline_seat_recline_extra,
  );
  static final exhaustionLevel4 = GameSystemViewModelItem(
    name: 'Exhaustion Level 4',
    icon: Symbols.battery_low,
  );
  static final exhaustionLevel5 = GameSystemViewModelItem(
    name: 'Exhaustion Level 5',
    icon: Symbols.battery_alert,
  );
  static final exhaustionLevel6 = GameSystemViewModelItem(
    name: 'Exhaustion Level 6',
    icon: Symbols.cancel,
  );

  static final spellSlots = GameSystemViewModelItem(
    name: 'Spell Slots',
    icon: Symbols.water_drop,
  );

  static final maxHp = GameSystemViewModelItem(
    name: 'Max HP',
    icon: Symbols.favorite,
  );

  static final currentHp = GameSystemViewModelItem(
    name: 'Current HP',
    icon: Symbols.heart_broken,
  );

  static final temporaryHp = GameSystemViewModelItem(
    name: 'Temporary HP',
    icon: Symbols.heart_plus,
  );

  static final armorClass = GameSystemViewModelItem(
    name: 'Armor Class',
    icon: Symbols.shield,
  );

  static final initiative = GameSystemViewModelItem(
    name: 'Initiative',
    icon: Symbols.flash_on,
  );

  static final speed = GameSystemViewModelItem(
    name: 'Speed',
    icon: Symbols.directions_walk,
  );

  static final rules = GameSystemViewModelItem(
    name: 'Rules',
    icon: Symbols.rule,
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
