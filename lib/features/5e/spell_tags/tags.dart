import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SpellTags {
  static final Map<String, Set<SpellType>> cantripSpellTypes = {
    "acid-splash": {SpellType.attack},
    "chill-touch": {SpellType.attack},
    "dancing-lights": {SpellType.utility},
    "druidcraft": {SpellType.utility},
    "eldritch-blast": {SpellType.attack},
    "fire-bolt": {SpellType.attack},
    "guidance": {SpellType.buff},
    "light": {SpellType.utility},
    "mage-hand": {SpellType.utility},
    "mending": {SpellType.utility},
    "message": {SpellType.utility},
    "minor-illusion": {SpellType.utility},
    "poison-spray": {SpellType.attack},
    "prestidigitation": {SpellType.utility},
    "produce-flame": {SpellType.attack},
    "ray-of-frost": {SpellType.attack},
    "resistance": {SpellType.buff},
    "sacred-flame": {SpellType.attack},
    "shillelagh": {SpellType.buff},
    "shocking-grasp": {SpellType.attack},
    "spare-the-dying": {SpellType.healing},
    "thaumaturgy": {SpellType.utility},
    "true-strike": {SpellType.buff},
    "vicious-mockery": {SpellType.attack},
  };
}

enum SpellType {
  healing,
  attack,
  buff,
  debuff,
  control,
  utility,
}

extension SpellTypeIcon on SpellType {
  IconData get icon {
    switch (this) {
      case SpellType.healing:
        return Symbols.healing;
      case SpellType.attack:
        return Symbols.skull;
      case SpellType.buff:
        return Symbols.taunt;
      case SpellType.debuff:
        return Symbols.person_off;
      case SpellType.control:
        return Symbols.guardian;
      case SpellType.utility:
        return Symbols.candle;
    }
  }

  String get title {
    switch (this) {
      case SpellType.healing:
        return "Healing";
      case SpellType.attack:
        return "Attack";
      case SpellType.buff:
        return "Buff";
      case SpellType.debuff:
        return "Debuff";
      case SpellType.control:
        return "Control";
      case SpellType.utility:
        return "Utility";
    }
  }
}

enum Condition {
  blinded,
  charmed,
  deafened,
  frightened,
  grappled,
  incapacitated,
  invisible,
  paralyzed,
  petrified,
  poisoned,
  prone,
  restrained,
  stunned,
  unconscious,
}

enum ExhaustionLevel {
  none,
  first,
  second,
  third,
  fourth,
  fifth,
  sixth,
}

enum AreaOfEffectType {
  cone,
  cube,
  cylinder,
  line,
  sphere,
}

enum DamageType {
  acid,
  bludgeoning,
  cold,
  fire,
  force,
  lightning,
  necrotic,
  piercing,
  poison,
  psychic,
  radiant,
  slashing,
  thunder,
}
