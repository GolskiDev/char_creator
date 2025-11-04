import 'package:spells_and_tools/features/5e/spells/view_models/spell_view_model.dart';
import 'package:spells_and_tools/features/5e/tags.dart';

import '../../../../common/interfaces/identifiable.dart';
import '../edit_spells/new_spell_model.dart';
import '../models/spell_casting_time.dart';
import '../models/spell_duration.dart' show SpellDuration;
import '../models/spell_range.dart';
import '../models/spell_school.dart';

class UserSpellModelV1 extends Identifiable {
  @override
  final String id;
  final String ownerId;
  final String name;
  final int level;
  final String description;
  final String? school;
  final bool? ritual;
  final String? castingTime;
  final String? range;
  final bool? requiresV;
  final bool? requiresS;
  final bool? requiresM;
  final String? material;
  final String? duration;
  final bool? requiresConcentration;
  final String? atHigherLevels;
  final List<String>? spellTypes;

  UserSpellModelV1({
    required this.id,
    required this.ownerId,
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
    required this.spellTypes,
  });

  factory UserSpellModelV1.fromMap(Map<String, dynamic> json) {
    return UserSpellModelV1(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      name: json['name'] as String,
      level: json['level'] as int,
      school: json['school'] as String?,
      ritual: json['ritual'] as bool?,
      castingTime: json['casting_time'] as String?,
      range: json['range'] as String,
      requiresV: json['requires_v'] as bool?,
      requiresS: json['requires_s'] as bool?,
      requiresM: json['requires_m'] as bool?,
      material: json['material'] as String?,
      duration: json['duration'] as String?,
      requiresConcentration: json['requires_concentration'] as bool?,
      atHigherLevels: json['at_higher_levels'] as String?,
      description: json['description'] as String,
      spellTypes: json['spellTypes'] as List<String>,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ownerId': ownerId,
      'name': name,
      'level': level,
      'school': school,
      'ritual': ritual,
      'casting_time': castingTime,
      'range': range,
      'requires_v': requiresV,
      'requires_s': requiresS,
      'requires_m': requiresM,
      'material': material,
      'duration': duration,
      'requires_concentration': requiresConcentration,
      'at_higher_levels': atHigherLevels,
      'description': description,
      'spellTypes': spellTypes,
    };
  }

  factory UserSpellModelV1.newFromNewSpellModel(
    NewSpellModel spell,
    String ownerId,
  ) {
    final id = IdGenerator.generateId(UserSpellModelV1);
    return UserSpellModelV1(
      id: id,
      ownerId: ownerId,
      name: spell.name,
      level: spell.spellLevel,
      school: spell.school.toString(),
      ritual: spell.canBeCastAsRitual,
      castingTime: spell.castingTime.toString(),
      range: spell.range.toString(),
      requiresV: spell.requiresVerbalComponent,
      requiresS: spell.requiresSomaticComponent,
      requiresM: spell.requiresMaterialComponent,
      material: spell.material,
      duration: spell.duration.toString(),
      requiresConcentration: spell.requiresConcentration,
      atHigherLevels: spell.atHigherLevels,
      description: spell.description,
      spellTypes: spell.spellTypes.toStringList(),
    );
  }

  SpellViewModel toSpellViewModel() {
    return SpellViewModel(
      id: id,
      name: name,
      description: description,
      spellLevel: level,
      school: SpellSchool.fromString(school ?? 'unknown'),
      atHigherLevels: atHigherLevels,
      requiresConcentration: requiresConcentration,
      canBeCastAsRitual: ritual,
      requiresVerbalComponent: requiresV,
      requiresSomaticComponent: requiresS,
      requiresMaterialComponent: requiresM,
      material: material,
      duration: duration != null ? SpellDuration.fromString(duration!) : null,
      range: duration != null ? SpellRange.fromString(range!) : null,
      castingTime: castingTime != null
          ? SpellCastingTime.fromString(castingTime!)
          : null,
      spellTypes: spellTypes != null
          ? SpellType.fromStringList(spellTypes!)
          : <SpellType>{},
    );
  }
}
