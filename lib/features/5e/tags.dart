import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class SpellTags {
  static final Map<String, Set<SpellType>> spellTypes = {
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
    "alarm": {SpellType.utility},
    "animal-friendship": {SpellType.utility},
    "bane": {SpellType.debuff},
    "bless": {SpellType.buff},
    "burning-hands": {SpellType.attack},
    "charm-person": {SpellType.control},
    "color-spray": {SpellType.control},
    "command": {SpellType.control},
    "comprehend-languages": {SpellType.utility},
    "create-or-destroy-water": {SpellType.utility},
    "cure-wounds": {SpellType.healing},
    "detect-evil-and-good": {SpellType.utility},
    "detect-magic": {SpellType.utility},
    "detect-poison-and-disease": {SpellType.utility},
    "disguise-self": {SpellType.utility},
    "divine-favor": {SpellType.buff},
    "entangle": {SpellType.control},
    "expeditious-retreat": {SpellType.utility},
    "faerie-fire": {SpellType.utility},
    "false-life": {SpellType.buff},
    "feather-fall": {SpellType.utility},
    "find-familiar": {SpellType.utility},
    "floating-disk": {SpellType.utility},
    "fog-cloud": {SpellType.utility},
    "goodberry": {SpellType.utility},
    "grease": {SpellType.control},
    "guiding-bolt": {SpellType.attack},
    "healing-word": {SpellType.healing},
    "hellish-rebuke": {SpellType.attack},
    "heroism": {SpellType.buff},
    "hideous-laughter": {SpellType.control},
    "hunters-mark": {SpellType.buff},
    "identify": {SpellType.utility},
    "illusory-script": {SpellType.utility},
    "inflict-wounds": {SpellType.attack},
    "jump": {SpellType.utility},
    "longstrider": {SpellType.utility},
    "mage-armor": {SpellType.buff},
    "magic-missile": {SpellType.attack},
    "protection-from-evil-and-good": {SpellType.buff},
    "purify-food-and-drink": {SpellType.utility},
    "sanctuary": {SpellType.utility},
    "shield": {SpellType.buff},
    "shield-of-faith": {SpellType.buff},
    "silent-image": {SpellType.utility},
    "sleep": {SpellType.control},
    "speak-with-animals": {SpellType.utility},
    "thunderwave": {SpellType.attack},
    "unseen-servant": {SpellType.utility},
    "acid-arrow": {SpellType.attack},
    "aid": {SpellType.buff},
    "alter-self": {SpellType.utility},
    "animal-messenger": {SpellType.utility},
    "arcane-lock": {SpellType.utility},
    "arcanists-magic-aura": {SpellType.utility},
    "augury": {SpellType.utility},
    "barkskin": {SpellType.buff},
    "blindnessdeafness": {SpellType.debuff},
    "blur": {SpellType.utility},
    "branding-smite": {SpellType.attack},
    "calm-emotions": {SpellType.control},
    "continual-flame": {SpellType.utility},
    "darkness": {SpellType.utility},
    "darkvision": {SpellType.utility},
    "detect-thoughts": {SpellType.utility},
    "enhance-ability": {SpellType.buff},
    "enlargereduce": {SpellType.buff},
    "enthrall": {SpellType.control},
    "find-steed": {SpellType.utility},
    "find-traps": {SpellType.utility},
    "flame-blade": {SpellType.attack},
    "flaming-sphere": {SpellType.attack},
    "gentle-repose": {SpellType.utility},
    "gust-of-wind": {SpellType.utility},
    "heat-metal": {SpellType.attack},
    "hold-person": {SpellType.control},
    "invisibility": {SpellType.utility},
    "knock": {SpellType.utility},
    "lesser-restoration": {SpellType.healing},
    "levitate": {SpellType.utility},
    "locate-animals-or-plants": {SpellType.utility},
    "locate-object": {SpellType.utility},
    "magic-mouth": {SpellType.utility},
    "magic-weapon": {SpellType.utility},
    "mirror-image": {SpellType.utility},
    "misty-step": {SpellType.utility},
    "moonbeam": {SpellType.attack},
    "pass-without-trace": {SpellType.utility},
    "prayer-of-healing": {SpellType.healing},
    "protection-from-poison": {SpellType.buff},
    "ray-of-enfeeblement": {SpellType.debuff},
    "rope-trick": {SpellType.utility},
    "scorching-ray": {SpellType.attack},
    "see-invisibility": {SpellType.utility},
    "shatter": {SpellType.attack},
    "silence": {SpellType.utility},
    "spider-climb": {SpellType.utility},
    "spike-growth": {SpellType.control},
    "spiritual-weapon": {SpellType.attack},
    "suggestion": {SpellType.control},
    "warding-bond": {SpellType.utility},
    "web": {SpellType.control},
    "zone-of-truth": {SpellType.utility},
    "animate-dead": {SpellType.utility},
    "beacon-of-hope": {SpellType.healing},
    "bestow-curse": {SpellType.debuff},
    "blink": {SpellType.utility},
    "call-lightning": {SpellType.attack},
    "clairvoyance": {SpellType.utility},
    "conjure-animals": {SpellType.utility},
    "counterspell": {SpellType.utility},
    "create-food-and-water": {SpellType.utility},
    "daylight": {SpellType.utility},
    "dispel-magic": {SpellType.utility},
    "fear": {SpellType.control},
    "fireball": {SpellType.attack},
    "fly": {SpellType.utility},
    "gaseous-form": {SpellType.utility},
    "glyph-of-warding": {SpellType.utility},
    "haste": {SpellType.buff},
    "hypnotic-pattern": {SpellType.control},
    "lightning-bolt": {SpellType.attack},
    "magic-circle": {SpellType.utility},
    "major-image": {SpellType.utility},
    "mass-healing-word": {SpellType.healing},
    "meld-into-stone": {SpellType.utility},
    "nondetection": {SpellType.utility},
    "phantom-steed": {SpellType.utility},
    "plant-growth": {SpellType.utility},
    "protection-from-energy": {SpellType.buff},
    "remove-curse": {SpellType.utility},
    "revivify": {SpellType.healing},
    "sending": {SpellType.utility},
    "sleet-storm": {SpellType.utility},
    "slow": {SpellType.control},
    "speak-with-dead": {SpellType.utility},
    "speak-with-plants": {SpellType.utility},
    "spirit-guardians": {SpellType.healing},
    "stinking-cloud": {SpellType.control},
    "tiny-hut": {SpellType.utility},
    "tongues": {SpellType.utility},
    "vampiric-touch": {SpellType.attack},
    "water-breathing": {SpellType.utility},
    "water-walk": {SpellType.utility},
    "wind-wall": {SpellType.utility},
    "arcane-eye": {SpellType.utility},
    "banishment": {SpellType.control},
    "black-tentacles": {SpellType.control},
    "blight": {SpellType.attack},
    "compulsion": {SpellType.control},
    "confusion": {SpellType.control},
    "conjure-minor-elementals": {SpellType.utility},
    "conjure-woodland-beings": {SpellType.utility},
    "control-water": {SpellType.utility},
    "death-ward": {SpellType.utility},
    "dimension-door": {SpellType.utility},
    "divination": {SpellType.utility},
    "dominate-beast": {SpellType.control},
    "fabricate": {SpellType.utility},
    "faithful-hound": {SpellType.utility},
    "fire-shield": {SpellType.buff},
    "freedom-of-movement": {SpellType.utility},
    "giant-insect": {SpellType.utility},
    "greater-invisibility": {SpellType.utility},
    "guardian-of-faith": {SpellType.utility},
    "hallucinatory-terrain": {SpellType.utility},
    "ice-storm": {SpellType.attack},
    "locate-creature": {SpellType.utility},
    "phantasmal-killer": {SpellType.attack},
    "polymorph": {SpellType.utility},
    "private-sanctum": {SpellType.utility},
    "resilient-sphere": {SpellType.utility},
    "secret-chest": {SpellType.utility},
    "stone-shape": {SpellType.utility},
    "stoneskin": {SpellType.buff},
    "wall-of-fire": {SpellType.attack},
  };
}

enum SpellType {
  healing,
  attack,
  buff,
  debuff,
  control,
  utility;

  static SpellType? fromString(String string) {
    return SpellType.values.firstWhereOrNull(
      (element) {
        return element.name == string || element.name == string.toLowerCase();
      },
    );
  }

  static Set<SpellType> fromStringList(Iterable<String> strings) {
    return strings
        .map((element) => SpellType.fromString(element))
        .nonNulls
        .toSet();
  }
}

extension SpellTypeList on Iterable<SpellType> {
  List<String> toStringList() {
    return map((element) => element.name).toList();
  }
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
