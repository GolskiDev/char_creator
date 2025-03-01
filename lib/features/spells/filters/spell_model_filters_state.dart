import '../models/spell_model.dart';

class SpellModelFiltersState {
  final String? searchText;

  SpellModelFiltersState({this.searchText});

  SpellModelFiltersState copyWith({
    String? Function()? searchText,
  }) {
    return SpellModelFiltersState(
      searchText: searchText != null ? searchText() : this.searchText,
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

  List<SpellModel> filterSpells(
    List<SpellModel> spells,
  ) {
    return spells.where(
      (spell) {
        return spellNameContainsSearchText(spell.name) ||
            spellDescriptionContainsSearchText(spell.description);
      },
    ).toList();
  }
}
