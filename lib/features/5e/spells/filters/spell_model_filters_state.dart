import 'package:spells_and_tools/features/5e/character/models/character_5e_model_v1.dart';

import '../../character/models/character_5e_class_model_v1.dart';
import '../../tags.dart';
import '../view_models/spell_view_model.dart';

class SpellModelFiltersState {
  final String? searchText;
  final bool? requiresConcentration;
  final bool? canBeCastAsRitual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;
  final Set<String> selectedSchools;
  final Set<String> castingTimeIds;
  final Set<String> rangeIds;
  final Set<String> durationIds;
  final Set<int> spellLevels;
  final Set<SpellType> spellTypes;
  final Set<ICharacter5eClassModelV1> characterClasses;
  final Character5eModelV1? character;

  SpellModelFiltersState({
    this.searchText,
    this.requiresConcentration,
    this.canBeCastAsRitual,
    this.requiresVerbalComponent,
    this.requiresSomaticComponent,
    this.requiresMaterialComponent,
    this.selectedSchools = const {},
    this.castingTimeIds = const {},
    this.rangeIds = const {},
    this.durationIds = const {},
    this.spellLevels = const {},
    this.spellTypes = const {},
    this.characterClasses = const {},
    this.character,
  });

  SpellModelFiltersState copyWith({
    String? Function()? searchTextSetter,
    bool? Function()? requiresConcentrationSetter,
    bool? Function()? canBeCastAsRitualSetter,
    bool? Function()? requiresVerbalComponentSetter,
    bool? Function()? requiresSomaticComponentSetter,
    bool? Function()? requiresMaterialComponentSetter,
    Set<String>? selectedSchools,
    Set<String>? castingTimeIds,
    Set<String>? rangeIds,
    Set<String>? durationIds,
    Set<int>? spellLevels,
    Set<SpellType>? spellTypes,
    Set<ICharacter5eClassModelV1>? characterClasses,
    Character5eModelV1? Function()? characterSetter,
  }) {
    return SpellModelFiltersState(
      searchText: searchTextSetter != null ? searchTextSetter() : searchText,
      requiresConcentration: requiresConcentrationSetter != null
          ? requiresConcentrationSetter()
          : requiresConcentration,
      canBeCastAsRitual: canBeCastAsRitualSetter != null
          ? canBeCastAsRitualSetter()
          : canBeCastAsRitual,
      requiresVerbalComponent: requiresVerbalComponentSetter != null
          ? requiresVerbalComponentSetter()
          : requiresVerbalComponent,
      requiresSomaticComponent: requiresSomaticComponentSetter != null
          ? requiresSomaticComponentSetter()
          : requiresSomaticComponent,
      requiresMaterialComponent: requiresMaterialComponentSetter != null
          ? requiresMaterialComponentSetter()
          : requiresMaterialComponent,
      selectedSchools: selectedSchools ?? this.selectedSchools,
      castingTimeIds: castingTimeIds ?? this.castingTimeIds,
      rangeIds: rangeIds ?? this.rangeIds,
      durationIds: durationIds ?? this.durationIds,
      spellLevels: spellLevels ?? this.spellLevels,
      spellTypes: spellTypes ?? this.spellTypes,
      characterClasses: characterClasses ?? this.characterClasses,
      character: characterSetter != null ? characterSetter() : character,
    );
  }

  bool spellNameContainsSearchText(String name) {
    if (searchText == null || searchText!.isEmpty) {
      return true;
    }

    return name.toLowerCase().contains(
          searchText!.toLowerCase(),
        );
  }

  bool spellDescriptionContainsSearchText(String description) {
    if (searchText == null || searchText!.isEmpty) {
      return true;
    }

    return description.toLowerCase().contains(
          searchText!.toLowerCase(),
        );
  }

  bool spellRequiresConcentration(bool? concentration) {
    if (requiresConcentration == null) {
      return true;
    }

    return concentration == requiresConcentration;
  }

  bool spellCanBeCastAsRitual(bool? ritual) {
    if (canBeCastAsRitual == null) {
      return true;
    }

    return ritual == canBeCastAsRitual;
  }

  bool spellRequiresVerbalComponent(bool? verbal) {
    if (requiresVerbalComponent == null) {
      return true;
    }

    return verbal == requiresVerbalComponent;
  }

  bool spellRequiresSomaticComponent(bool? somatic) {
    if (requiresSomaticComponent == null) {
      return true;
    }

    return somatic == requiresSomaticComponent;
  }

  bool spellRequiresMaterialComponent(bool? material) {
    if (requiresMaterialComponent == null) {
      return true;
    }

    return material == requiresMaterialComponent;
  }

  bool spellIsInSelectedSchools(String? school) {
    if (selectedSchools.isEmpty) {
      return true;
    }

    return school != null && selectedSchools.contains(school);
  }

  bool spellMatchesCastingTime(String? castingTimeId) {
    if (castingTimeIds.isEmpty) {
      return true;
    }

    return castingTimeId != null && castingTimeIds.contains(castingTimeId);
  }

  bool spellMatchesRange(String? rangeId) {
    if (rangeIds.isEmpty) {
      return true;
    }

    return rangeId != null && rangeIds.contains(rangeId);
  }

  bool spellMatchesDuration(String? durationId) {
    if (durationIds.isEmpty) {
      return true;
    }

    return durationId != null && durationIds.contains(durationId);
  }

  bool spellMatchesLevel(int? level) {
    if (spellLevels.isEmpty) {
      return true;
    }

    return level != null && spellLevels.contains(level);
  }

  bool spellInType(Set<SpellType>? types) {
    if (spellTypes.isEmpty) {
      return true;
    }

    return types != null &&
        spellTypes.containsAll(
          types,
        );
  }

  bool spellMatchesCharacterClasses(Set<ICharacter5eClassModelV1>? classes) {
    if (characterClasses.isEmpty) {
      return true;
    }

    return classes != null &&
        characterClasses
            .any((characterClass) => classes.contains(characterClass));
  }

  bool spellIsForCharacter(SpellViewModel spell) {
    if (character == null) {
      return true;
    }

    final spellIsAvailableForAnyCharacterClass = character!.classesStates.any(
      (classState) => classState.classModel.availableSpells.contains(spell.id),
    );
    return spellIsAvailableForAnyCharacterClass;
  }

  List<SpellViewModel> filterSpells(
    List<SpellViewModel> spells,
  ) {
    final isCharacterFilterUsed = character != null;
    return spells.where(
      (spell) {
        return (spellNameContainsSearchText(spell.name) ||
                spellDescriptionContainsSearchText(spell.description)) &&
            spellRequiresConcentration(spell.requiresConcentration) &&
            spellCanBeCastAsRitual(spell.canBeCastAsRitual) &&
            spellRequiresVerbalComponent(spell.requiresVerbalComponent) &&
            spellRequiresSomaticComponent(spell.requiresSomaticComponent) &&
            spellRequiresMaterialComponent(spell.requiresMaterialComponent) &&
            spellIsInSelectedSchools(spell.school) &&
            spellMatchesCastingTime(spell.castingTime?.id) &&
            spellMatchesRange(spell.range?.id) &&
            spellMatchesDuration(spell.duration?.id) &&
            spellMatchesLevel(spell.spellLevel) &&
            spellInType(spell.spellTypes) &&
            (isCharacterFilterUsed
                ? spellIsForCharacter(spell)
                : spellMatchesCharacterClasses(spell.characterClasses));
      },
    ).toList();
  }
}
