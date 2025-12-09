import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class GameSystemViewModel {
  static const strength = GameSystemViewModelItem(
    name: 'Strength',
    icon: Icons.fitness_center,
  );
  static const dexterity = GameSystemViewModelItem(
    name: 'Dexterity',
    icon: Icons.directions_run,
  );
  static const constitution = GameSystemViewModelItem(
    name: 'Constitution',
    icon: Icons.health_and_safety_outlined,
  );
  static const intelligence = GameSystemViewModelItem(
    name: 'Intelligence',
    icon: Icons.psychology_outlined,
  );
  static const wisdom = GameSystemViewModelItem(
    name: 'Wisdom',
    icon: Icons.lightbulb_outline,
  );
  static const charisma = GameSystemViewModelItem(
    name: 'Charisma',
    icon: Symbols.sentiment_very_satisfied,
  );

  static const spellLevel = GameSystemViewModelItem(
    name: 'Spell Level',
    icon: Icons.star,
  );
  static const castingTime = GameSystemViewModelItem(
    name: 'Casting Time',
    icon: Icons.timer,
  );
  static const range = GameSystemViewModelItem(
    name: 'Range',
    icon: Symbols.swap_calls,
  );
  static const duration = GameSystemViewModelItem(
    name: 'Duration',
    icon: Icons.timelapse,
  );
  static const concentration = GameSystemViewModelItem(
    name: 'Requires Concentration',
    icon: Symbols.mindfulness,
  );
  static const ritual = GameSystemViewModelItem(
    name: 'Can Be Cast As Ritual',
    icon: Symbols.person_celebrate,
  );
  static const verbalComponent = GameSystemViewModelItem(
    name: 'Verbal Component',
    icon: Icons.record_voice_over,
  );
  static const somaticComponent = GameSystemViewModelItem(
    name: 'Somatic Component',
    icon: Icons.waving_hand,
  );
  static const materialComponent = GameSystemViewModelItem(
    name: 'Material Component',
    icon: Icons.category,
  );
  static const verbalComponentShort = GameSystemViewModelItem(
    name: 'Verbal',
    icon: Icons.record_voice_over,
  );
  static const somaticComponentShort = GameSystemViewModelItem(
    name: 'Somatic',
    icon: Icons.waving_hand,
  );
  static const materialComponentShort = GameSystemViewModelItem(
    name: 'Material',
    icon: Icons.category,
  );

  static const school = GameSystemViewModelItem(
    name: 'School',
    icon: Icons.book,
  );
  static const spellType = GameSystemViewModelItem(
    name: 'Spell Type',
    icon: Symbols.emoji_symbols,
  );
  static const characterClass = GameSystemViewModelItem(
    name: 'Class',
    icon: Symbols.identity_platform,
  );

  static const character = GameSystemViewModelItem(
    name: 'Character',
    icon: Symbols.person,
  );

  static const spells = GameSystemViewModelItem(
    name: 'Spells',
    icon: Symbols.magic_button,
  );

  static const atHigherLevels = GameSystemViewModelItem(
    name: 'At Higher Levels',
    icon: Symbols.arrow_circle_up,
  );

  static const abilityScores = GameSystemViewModelItem(
    name: 'Ability Scores',
    icon: Icons.bar_chart,
  );

  static const modifier = GameSystemViewModelItem(
    name: 'Modifier',
    icon: Icons.add_circle_outline,
  );

  static const savingThrowModifier = GameSystemViewModelItem(
    name: 'Saving Throw',
    icon: Icons.security,
  );

  static const skills = GameSystemViewModelItem(
    name: 'Skills',
    icon: Symbols.emoji_objects,
  );

  static const athletics = GameSystemViewModelItem(
    name: 'Athletics',
    icon: Symbols.sports_gymnastics,
  );
  static const acrobatics = GameSystemViewModelItem(
    name: 'Acrobatics',
    icon: Symbols.sports_kabaddi,
  );
  static const sleightOfHand = GameSystemViewModelItem(
    name: 'Sleight of Hand',
    icon: Symbols.handshake,
  );
  static const stealth = GameSystemViewModelItem(
    name: 'Stealth',
    icon: Symbols.visibility_off,
  );
  static const arcana = GameSystemViewModelItem(
    name: 'Arcana',
    icon: Symbols.auto_awesome,
  );
  static const history = GameSystemViewModelItem(
    name: 'History',
    icon: Symbols.history_edu,
  );
  static const investigation = GameSystemViewModelItem(
    name: 'Investigation',
    icon: Symbols.search,
  );
  static const nature = GameSystemViewModelItem(
    name: 'Nature',
    icon: Symbols.park,
  );
  static const religion = GameSystemViewModelItem(
    name: 'Religion',
    icon: Symbols.temple_hindu,
  );
  static const animalHandling = GameSystemViewModelItem(
    name: 'Animal Handling',
    icon: Symbols.pets,
  );
  static const insight = GameSystemViewModelItem(
    name: 'Insight',
    icon: Symbols.lightbulb,
  );
  static const medicine = GameSystemViewModelItem(
    name: 'Medicine',
    icon: Symbols.medical_services,
  );
  static const perception = GameSystemViewModelItem(
    name: 'Perception',
    icon: Symbols.visibility,
  );
  static const survival = GameSystemViewModelItem(
    name: 'Survival',
    icon: Symbols.camping,
  );
  static const deception = GameSystemViewModelItem(
    name: 'Deception',
    icon: Symbols.mood_bad,
  );
  static const intimidation = GameSystemViewModelItem(
    name: 'Intimidation',
    icon: Symbols.warning,
  );
  static const performance = GameSystemViewModelItem(
    name: 'Performance',
    icon: Symbols.theater_comedy,
  );
  static const persuasion = GameSystemViewModelItem(
    name: 'Persuasion',
    icon: Symbols.thumb_up,
  );

  static const conditions = GameSystemViewModelItem(
    name: 'Conditions',
    icon: Symbols.warning_amber,
  );

  static const blinded = GameSystemViewModelItem(
    name: 'Blinded',
    icon: Symbols.visibility_off,
  );
  static const charmed = GameSystemViewModelItem(
    name: 'Charmed',
    icon: Symbols.favorite,
  );
  static const deafened = GameSystemViewModelItem(
    name: 'Deafened',
    icon: Symbols.hearing_disabled,
  );
  static const frightened = GameSystemViewModelItem(
    name: 'Frightened',
    icon: Symbols.warning,
  );
  static const grappled = GameSystemViewModelItem(
    name: 'Grappled',
    icon: Symbols.sports_mma,
  );
  static const incapacitated = GameSystemViewModelItem(
    name: 'Incapacitated',
    icon: Symbols.bed,
  );
  static const invisible = GameSystemViewModelItem(
    name: 'Invisible',
    icon: Symbols.visibility,
  );
  static const paralyzed = GameSystemViewModelItem(
    name: 'Paralyzed',
    icon: Symbols.accessibility_new,
  );
  static const petrified = GameSystemViewModelItem(
    name: 'Petrified',
    icon: Icons.terrain,
  );
  static const poisoned = GameSystemViewModelItem(
    name: 'Poisoned',
    icon: Symbols.science,
  );
  static const prone = GameSystemViewModelItem(
    name: 'Prone',
    icon: Symbols.airline_seat_flat,
  );
  static const restrained = GameSystemViewModelItem(
    name: 'Restrained',
    icon: Symbols.lock,
  );
  static const stunned = GameSystemViewModelItem(
    name: 'Stunned',
    icon: Symbols.flash_on,
  );
  static const unconscious = GameSystemViewModelItem(
    name: 'Unconscious',
    icon: Symbols.hotel,
  );

  static const exhaustionLevel0 = GameSystemViewModelItem(
    name: 'No Exhaustion',
    icon: Symbols.sentiment_very_satisfied,
  );
  static const exhaustionLevel1 = GameSystemViewModelItem(
    name: 'Exhaustion Level 1',
    icon: Symbols.directions_walk,
  );
  static const exhaustionLevel2 = GameSystemViewModelItem(
    name: 'Exhaustion Level 2',
    icon: Symbols.stairs,
  );
  static const exhaustionLevel3 = GameSystemViewModelItem(
    name: 'Exhaustion Level 3',
    icon: Symbols.airline_seat_recline_extra,
  );
  static const exhaustionLevel4 = GameSystemViewModelItem(
    name: 'Exhaustion Level 4',
    icon: Symbols.battery_low,
  );
  static const exhaustionLevel5 = GameSystemViewModelItem(
    name: 'Exhaustion Level 5',
    icon: Symbols.battery_alert,
  );
  static const exhaustionLevel6 = GameSystemViewModelItem(
    name: 'Exhaustion Level 6',
    icon: Symbols.cancel,
  );

  static const spellSlots = GameSystemViewModelItem(
    name: 'Spell Slots',
    icon: Symbols.water_drop,
  );

  static const maxHp = GameSystemViewModelItem(
    name: 'Max HP',
    icon: Symbols.favorite,
  );

  static const currentHp = GameSystemViewModelItem(
    name: 'Current HP',
    icon: Symbols.heart_broken,
  );

  static const temporaryHp = GameSystemViewModelItem(
    name: 'Temporary HP',
    icon: Symbols.heart_plus,
  );

  static const armorClass = GameSystemViewModelItem(
    name: 'Armor Class',
    icon: Symbols.shield,
  );

  static const initiative = GameSystemViewModelItem(
    name: 'Initiative',
    icon: Symbols.flash_on,
  );

  static const speed = GameSystemViewModelItem(
    name: 'Speed',
    icon: Symbols.directions_walk,
  );

  static const rules = GameSystemViewModelItem(
    name: 'Rules',
    icon: Symbols.receipt_long,
  );

  static const note = GameSystemViewModelItem(
    name: 'Note',
    icon: Symbols.note,
  );

  static const cardMode = GameSystemViewModelItem(
    name: 'Card Mode',
    icon: Symbols.view_module,
  );

  static const listMode = GameSystemViewModelItem(
    name: 'List Mode',
    icon: Symbols.view_list,
  );

  static const customValue = GameSystemViewModelItem(
    name: 'Custom Value',
    icon: Symbols.adjust,
  );

  static const account = GameSystemViewModelItem(
    name: 'Account',
    icon: Symbols.account_circle,
  );

  static const contactUs = GameSystemViewModelItem(
    name: 'Contact Us',
    icon: Symbols.email,
  );

  static const updateAvailable = GameSystemViewModelItem(
    name: 'Update Available',
    icon: Symbols.system_update,
  );

  static const signIn = GameSystemViewModelItem(
    name: 'Sign In',
    icon: Symbols.login,
  );

  static const name = GameSystemViewModelItem(
    name: 'Name',
    icon: Symbols.signature,
  );

  static const description = GameSystemViewModelItem(
    name: 'Description',
    icon: Symbols.description,
  );

  static const save = GameSystemViewModelItem(
    name: 'Save',
    icon: Symbols.save,
  );

  static const edit = GameSystemViewModelItem(
    name: 'Edit',
    icon: Symbols.edit,
  );

  static const collection = GameSystemViewModelItem(
    name: 'Collection',
    icon: Symbols.folder,
  );

  static const lightTheme = GameSystemViewModelItem(
    name: "Light Theme",
    icon: Symbols.wb_sunny,
  );

  static const darkTheme = GameSystemViewModelItem(
    name: "Dark Theme",
    icon: Symbols.nights_stay,
  );

  static const systemTheme = GameSystemViewModelItem(
    name: "System Theme",
    icon: Symbols.settings_suggest,
  );

  static const licenses = GameSystemViewModelItem(
    name: "Licenses",
    icon: Symbols.article,
  );

  static const aboutApp = GameSystemViewModelItem(
    name: "About App",
    icon: Symbols.info,
  );
}

class GameSystemViewModelItem {
  final String name;
  final String? link;
  final IconData? icon;

  const GameSystemViewModelItem({
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
