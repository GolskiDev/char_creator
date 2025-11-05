import '../models/spell_casting_time.dart';
import '../models/spell_duration.dart';
import '../models/spell_range.dart';
import '../models/spell_school.dart';
import '../view_models/spell_view_model.dart';

class SRDSpellModelV1 {
  final String id;
  final String name;
  final int level;
  final String? school;
  final bool ritual;
  final String? castingTime;
  final String range;
  final bool requiresV;
  final bool requiresS;
  final bool requiresM;
  final String? material;
  final String duration;
  final bool requiresConcentration;
  final String? atHigherLevels;
  final String description;

  SRDSpellModelV1({
    required this.id,
    required this.name,
    required this.level,
    required this.school,
    required this.ritual,
    required this.castingTime,
    required this.range,
    required this.requiresV,
    required this.requiresS,
    required this.requiresM,
    required this.material,
    required this.duration,
    required this.requiresConcentration,
    required this.atHigherLevels,
    required this.description,
  });

  factory SRDSpellModelV1.fromMap(Map<String, dynamic> json) {
    return SRDSpellModelV1(
      id: json['id'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      school: json['school'] as String?,
      ritual: json['ritual'] as bool,
      castingTime: json['casting_time'] as String?,
      range: json['range'] as String,
      requiresV: json['requires_v'] as bool,
      requiresS: json['requires_s'] as bool,
      requiresM: json['requires_m'] as bool,
      material: json['material'] as String?,
      duration: json['duration'] as String,
      requiresConcentration: json['requires_concentration'] as bool,
      atHigherLevels: json['at_higher_levels'] as String?,
      description: json['description'] as String,
    );
  }

  SpellViewModel toSpellViewModel() {
    return SpellViewModel(
      ownerId: 'system',
      id: id,
      name: name,
      description: description,
      spellLevel: level,
      school: SpellSchool.tryFromString(school ?? 'unknown'),
      atHigherLevels: atHigherLevels,
      requiresConcentration: requiresConcentration,
      canBeCastAsRitual: ritual,
      requiresVerbalComponent: requiresV,
      requiresSomaticComponent: requiresS,
      requiresMaterialComponent: requiresM,
      material: material,
      duration: SpellDuration.fromString(duration),
      range: SpellRange.fromString(range),
      castingTime: castingTime != null
          ? SpellCastingTime.fromString(castingTime!)
          : null,
    );
  }
}
