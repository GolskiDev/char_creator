import 'spell_duration.dart';
import 'spell_range.dart';
import 'spell_casting_time.dart';

class SpellModel {
  final String id;
  final String name;
  final String description;

  final int spellLevel;

  final String? school;

  final bool? requiresConcentration;
  final bool? canBeCastAsRitual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;
  final String? material;

  final SpellDuration? duration;
  final SpellRange? range;
  final SpellCastingTime? castingTime;

  SpellModel({
    required this.id,
    required this.name,
    required this.description,
    required this.spellLevel,
    this.school,
    this.requiresConcentration,
    this.canBeCastAsRitual,
    this.requiresVerbalComponent,
    this.requiresSomaticComponent,
    this.requiresMaterialComponent,
    this.material,    
    this.duration,
    this.range,
    this.castingTime,
  });
}

extension SpellLevelString on SpellModel{
  String get spellLevelString {
    switch (spellLevel) {
      case 0:
        return 'Cantrip';
      case 1:
        return '1st Level';
      case 2:
        return '2nd Level';
      case 3:
        return '3rd Level';
      default:
        return '${spellLevel}th Level';
    }
  }
}