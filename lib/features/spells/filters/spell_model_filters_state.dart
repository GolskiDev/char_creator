import '../models/spell_model.dart';

class SpellModelFiltersState {
  final String? searchText;
  final bool? requiresConcentration;
  final bool? canBeCastAsRitual;
  final bool? requiresVerbalComponent;
  final bool? requiresSomaticComponent;
  final bool? requiresMaterialComponent;

  SpellModelFiltersState({
    this.searchText,
    this.requiresConcentration,
    this.canBeCastAsRitual,
    this.requiresVerbalComponent,
    this.requiresSomaticComponent,
    this.requiresMaterialComponent,
  });

  SpellModelFiltersState copyWith({
    String? Function()? searchTextSetter,
    bool? Function()? requiresConcentrationSetter,
    bool? Function()? canBeCastAsRitualSetter,
    bool? Function()? requiresVerbalComponentSetter,
    bool? Function()? requiresSomaticComponentSetter,
    bool? Function()? requiresMaterialComponentSetter,
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

  List<SpellModel> filterSpells(
    List<SpellModel> spells,
  ) {
    return spells.where(
      (spell) {
        return (spellNameContainsSearchText(spell.name) ||
                spellDescriptionContainsSearchText(spell.description)) &&
            spellRequiresConcentration(spell.requiresConcentration) &&
            spellCanBeCastAsRitual(spell.canBeCastAsRitual) &&
            spellRequiresVerbalComponent(spell.requiresVerbalComponent) &&
            spellRequiresSomaticComponent(spell.requiresSomaticComponent) &&
            spellRequiresMaterialComponent(spell.requiresMaterialComponent);
      },
    ).toList();
  }
}
