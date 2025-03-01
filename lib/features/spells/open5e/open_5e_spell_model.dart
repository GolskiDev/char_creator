import '../models/spell_model.dart';
import '../models/spell_duration.dart';
import '../models/spell_range.dart';
import '../models/spell_casting_time.dart';

class Open5eSpellModelV1 {
  final String name;
  final String description;
  final String slug;
  final int level;
  final String? school;
  final bool? concentration;
  final bool? ritual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;
  final String? duration;
  final String? range;
  final String? materialComponent;
  final String? castingTime;

  Open5eSpellModelV1({
    required this.slug,
    required this.name,
    required this.description,
    required this.level,
    this.school,
    this.concentration,
    this.ritual,
    this.requiresVerbalComponent,
    this.requiresSomaticComponent,
    this.requiresMaterialComponent,
    this.materialComponent,
    this.duration,
    this.range,
    this.castingTime,
  });

  factory Open5eSpellModelV1.fromJson(Map<String, dynamic> json) {
    return Open5eSpellModelV1(
      slug: json['slug'],
      name: json['name'],
      description: json['desc'],
      level: json['level_int'],
      school: json['school'],
      concentration: json['requires_concentration'],
      ritual: json['can_be_cast_as_ritual'],
      requiresVerbalComponent: json['requires_verbal_components'],
      requiresSomaticComponent: json['requires_somatic_components'],
      requiresMaterialComponent: json['requires_material_components'],
      materialComponent: json['material'],
      duration: json['duration'],
      range: json['range'],
      castingTime: json['casting_time'],
    );
  }

  SpellModel toSpellModel() {
    return SpellModel(
      id: slug,
      name: name,
      description: description,
      spellLevel: level,
      school: school,
      requiresConcentration: concentration,
      canBeCastAsRitual: ritual,
      requiresVerbalComponent: requiresVerbalComponent,
      requiresSomaticComponent: requiresSomaticComponent,
      requiresMaterialComponent: requiresMaterialComponent,
      material: materialComponent?.isNotEmpty ?? false ? materialComponent : null,
      duration: duration != null ? SpellDuration.fromString(duration!) : null,
      range: range != null ? SpellRange.fromString(range!) : null,
      castingTime: castingTime != null ? SpellCastingTime.fromString(castingTime!) : null,
    );
  }
}