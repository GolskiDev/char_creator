import 'package:char_creator/features/5e/classes/class_spells.dart';

enum CharacterClass {
  barbarian,
  bard,
  cleric,
  druid,
  fighter,
  monk,
  paladin,
  ranger,
  rogue,
  sorcerer,
  warlock,
  wizard;

  List<String> get classSpellsIds {
    return switch (this) {
      CharacterClass.bard => ClassSpells.bard,
      CharacterClass.cleric => ClassSpells.cleric,
      CharacterClass.druid => ClassSpells.druid,
      CharacterClass.paladin => ClassSpells.paladin,
      CharacterClass.ranger => ClassSpells.ranger,
      CharacterClass.sorcerer => ClassSpells.sorcerer,
      CharacterClass.warlock => ClassSpells.warlock,
      CharacterClass.wizard => ClassSpells.wizard,
      CharacterClass.rogue => [],
      CharacterClass.monk => [],
      CharacterClass.fighter => [],
      CharacterClass.barbarian => [],
    };
  }

  @override
  String toString() {
    return name.replaceRange(0, 1, name[0].toUpperCase());
  }
}
