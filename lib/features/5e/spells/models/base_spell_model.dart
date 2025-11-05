import '../../tags.dart';
import 'spell_casting_time.dart';
import 'spell_duration.dart';
import 'spell_range.dart';
import 'spell_school.dart';

class BaseSpellModel {
  final String name;
  final String description;

  final int spellLevel;

  final SpellSchool? school;

  final bool? requiresConcentration;
  final bool? canBeCastAsRitual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;
  final String? material;

  final SpellDuration? duration;
  final SpellRange? range;
  final SpellCastingTime? castingTime;

  final String? atHigherLevels;

  final String? imageUrl;

  final Set<SpellType> spellTypes;

  BaseSpellModel({
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
    this.atHigherLevels,
    this.imageUrl,
    this.spellTypes = const {},
  });

  BaseSpellModel copyWith({
    String? name,
    String? description,
    int? spellLevel,
    SpellSchool? school,
    bool? requiresConcentration,
    bool? canBeCastAsRitual,
    bool? requiresVerbalComponent,
    bool? requiresSomaticComponent,
    bool? requiresMaterialComponent,
    String? material,
    SpellDuration? duration,
    SpellRange? range,
    SpellCastingTime? castingTime,
    String? atHigherLevels,
    String? imageUrl,
    Set<SpellType>? spellTypes,
  }) {
    return BaseSpellModel(
      name: name ?? this.name,
      description: description ?? this.description,
      spellLevel: spellLevel ?? this.spellLevel,
      school: school ?? this.school,
      requiresConcentration:
          requiresConcentration ?? this.requiresConcentration,
      canBeCastAsRitual: canBeCastAsRitual ?? this.canBeCastAsRitual,
      requiresVerbalComponent:
          requiresVerbalComponent ?? this.requiresVerbalComponent,
      requiresSomaticComponent:
          requiresSomaticComponent ?? this.requiresSomaticComponent,
      requiresMaterialComponent:
          requiresMaterialComponent ?? this.requiresMaterialComponent,
      material: material ?? this.material,
      duration: duration ?? this.duration,
      range: range ?? this.range,
      castingTime: castingTime ?? this.castingTime,
      atHigherLevels: atHigherLevels ?? this.atHigherLevels,
      imageUrl: imageUrl ?? this.imageUrl,
      spellTypes: spellTypes ?? this.spellTypes,
    );
  }

  factory BaseSpellModel.fromMap(Map<String, dynamic> map) {
    return BaseSpellModel(
      name: map['name'] as String,
      description: map['description'] as String,
      spellLevel: map['spellLevel'] as int,
      school: map['school'] != null
          ? SpellSchool.tryFromString(map['school'] as String)
          : null,
      requiresConcentration: map['requiresConcentration'] as bool?,
      canBeCastAsRitual: map['canBeCastAsRitual'] as bool?,
      requiresVerbalComponent: map['requiresVerbalComponent'] as bool?,
      requiresSomaticComponent: map['requiresSomaticComponent'] as bool?,
      requiresMaterialComponent: map['requiresMaterialComponent'] as bool?,
      material: map['material'] as String?,
      duration: map['duration'] != null
          ? SpellDuration.fromString(map['duration'] as String)
          : null,
      range: map['range'] != null
          ? SpellRange.fromString(map['range'] as String)
          : null,
      castingTime: map['castingTime'] != null
          ? SpellCastingTime.fromString(map['castingTime'] as String)
          : null,
      atHigherLevels: map['atHigherLevels'] as String?,
      imageUrl: map['imageUrl'] as String?,
      spellTypes: map['spellTypes'] != null
          ? (map['spellTypes'] as List<dynamic>)
              .map((e) => SpellType.fromString(e as String))
              .nonNulls
              .toSet()
          : <SpellType>{},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'spellLevel': spellLevel,
      'school': school.toString(),
      'requiresConcentration': requiresConcentration,
      'canBeCastAsRitual': canBeCastAsRitual,
      'requiresVerbalComponent': requiresVerbalComponent,
      'requiresSomaticComponent': requiresSomaticComponent,
      'requiresMaterialComponent': requiresMaterialComponent,
      'material': material,
      'duration': duration?.toString(),
      'range': range?.toString(),
      'castingTime': castingTime?.toString(),
      'atHigherLevels': atHigherLevels,
      'imageUrl': imageUrl,
      'spellTypes': spellTypes.map((e) => e.toString()).toList(),
    };
  }

  static int maxNameLength = 150;
  static int maxDescriptionLength = 5000;
  static int maxMaterialLength = 200;

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Name cannot be empty';
    }
    if (name.length > maxNameLength) {
      return 'Name cannot be longer than $maxNameLength characters';
    }
    return null;
  }

  static String? validateDescription(String? description) {
    if (description == null || description.isEmpty) {
      return 'Description cannot be empty';
    }
    if (description.length > maxDescriptionLength) {
      return 'Description cannot be longer than $maxDescriptionLength characters';
    }
    return null;
  }

  static String? validateSpellLevel(int? level) {
    if (level == null) {
      return 'Spell level is required';
    }
    if (level < 0 || level > 9) {
      return 'Spell level must be between 0 and 9';
    }
    return null;
  }
}
