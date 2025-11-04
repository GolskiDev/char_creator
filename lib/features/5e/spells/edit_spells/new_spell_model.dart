import '../../character/models/character_5e_class_model_v1.dart';
import '../../tags.dart';
import '../models/spell_casting_time.dart';
import '../models/spell_duration.dart';
import '../models/spell_range.dart';
import '../models/spell_school.dart';

class NewSpellModel {
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
  final Set<ICharacter5eClassModelV1> characterClasses;

  NewSpellModel({
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
    this.characterClasses = const {},
  });

  NewSpellModel copyWith({
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
    Set<ICharacter5eClassModelV1>? classes,
  }) {
    return NewSpellModel(
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
      characterClasses: classes ?? this.characterClasses,
    );
  }

  static int maxNameLength = 150;
  static int maxDescriptionLength = 5000;

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
    return '';
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
