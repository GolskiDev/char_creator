import 'package:char_creator/features/5e/character/repository/character_repository.dart';
import 'package:char_creator/features/5e/spells/filters/spell_model_filters_state.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../character/models/character_5e_model.dart';
import 'view_models/spell_view_model.dart';
import 'widgets/add_to_character_menu.dart';
import 'widgets/spell_filter_drawer.dart';

class ListOfSpellsPage extends HookConsumerWidget {
  const ListOfSpellsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCantrips = ref.watch(spellViewModelsProvider);
    final allCharactersAsync = ref.watch(charactersStreamProvider);

    final spellFilters = useState(
      SpellModelFiltersState(),
    );

    final selectedCharacterId = useState<String?>(null);

    final List<Character5eModel> characters;
    switch (allCharactersAsync) {
      case AsyncValue(value: final List<Character5eModel> loadedCharacters):
        characters = loadedCharacters;
        break;
      default:
        characters = [];
        break;
    }

    final selectedCharacter = characters.firstWhereOrNull(
      (element) => element.id == selectedCharacterId.value,
    );

    final List<RadioMenuButton> addToCharacterEntries = characters.isNotEmpty
        ? AddToCharacterMenu().generateMenuEntries(
            context,
            characters,
            selectedCharacterId.value,
            (newId) {
              selectedCharacterId.value = newId;
            },
          )
        : [];

    addToCharacterWidgetBuilder(SpellViewModel spell) => IconButton(
          icon: selectedCharacter != null &&
                  selectedCharacter.spellIds.contains(spell.id)
              ? const Icon(Symbols.person_check)
              : const Icon(Symbols.add),
          onPressed: () async {
            if (selectedCharacter != null) {
              final updatedCharacter = selectedCharacter.copyWith(
                spellIds: selectedCharacter.spellIds.union({spell.id}),
              );
              await ref
                  .read(characterRepositoryProvider)
                  .updateCharacter(updatedCharacter);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ${spell.name} to ${selectedCharacter.name}',
                    ),
                  ),
                );
              }
            }
          },
        );

    final isAddToCharacterEnabled = selectedCharacter != null;

    final searchController = useTextEditingController(
      text: spellFilters.value.searchText,
    );
    final searchFocusNode = useFocusNode(
      canRequestFocus: true,
    );

    final isSearchVisible =
        searchFocusNode.hasFocus || searchController.text.isNotEmpty;

    final menuEntries = [
      SubmenuButton(
        menuChildren: addToCharacterEntries,
        leadingIcon: Icon(
          Symbols.person_add,
        ),
        child: Text("Add to Character"),
      )
    ];

    final appBarTitle = Builder(
      builder: (context) {
        return Stack(
          fit: StackFit.passthrough,
          children: [
            Visibility(
              visible: !isSearchVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainInteractivity: true,
              maintainState: true,
              maintainSemantics: true,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Spells',
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                  ),
                ),
                onTap: () {
                  searchFocusNode.requestFocus();
                  FocusScope.of(context).requestFocus(searchFocusNode);
                },
              ),
            ),
            Visibility(
              visible: isSearchVisible,
              maintainSize: true,
              maintainAnimation: true,
              maintainInteractivity: true,
              maintainState: true,
              maintainSemantics: true,
              child: TextField(
                focusNode: searchFocusNode,
                canRequestFocus: true,
                controller: searchController,
                onTapOutside: (_) {
                  searchFocusNode.unfocus();
                },
                onChanged: (value) {
                  spellFilters.value = spellFilters.value.copyWith(
                    searchTextSetter: () {
                      return value;
                    },
                  );
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      spellFilters.value = spellFilters.value.copyWith(
                        searchTextSetter: () => null,
                      );
                      searchController.clear();
                      searchFocusNode.unfocus();
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
      endDrawer: spellFilterDrawer(
        allCantrips,
        spellFilters,
      ),
      appBar: AppBar(
        title: appBarTitle,
        actions: [
          MenuAnchor(
            menuChildren: menuEntries,
            builder: (context, menuController, child) {
              return IconButton(
                icon: const Icon(Icons.more_vert),
                isSelected: menuController.isOpen,
                onPressed: () {
                  menuController.isOpen
                      ? menuController.close()
                      : menuController.open();
                },
              );
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.tune),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: isSearchVisible
          ? null
          : FloatingActionButton(
              onPressed: () {
                searchFocusNode.requestFocus();
                FocusScope.of(context).requestFocus(searchFocusNode);
              },
              child: const Icon(Icons.search),
            ),
      body: allCantrips.when(
        data: (cantrips) {
          final filteredCantrips =
              spellFilters.value.filterSpells(cantrips.map((e) => e).toList());
          return SafeArea(
            child: Stack(
              children: [
                ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  itemCount: filteredCantrips.length,
                  itemBuilder: (context, index) {
                    final cantrip = filteredCantrips[index];
                    return Card.outlined(
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        leading: isAddToCharacterEnabled
                            ? addToCharacterWidgetBuilder(cantrip)
                            : null,
                        title: Text(cantrip.name),
                        onTap: () {
                          context.go('/spells/${cantrip.id}');
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 8,
                    );
                  },
                ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }

  SpellFilterDrawer spellFilterDrawer(
      AsyncValue<List<SpellViewModel>> allCantrips,
      ValueNotifier<SpellModelFiltersState> spellFilters) {
    return SpellFilterDrawer(
      allSpellModels: allCantrips.when(
        data: (cantrips) => cantrips.toList(),
        loading: () => [],
        error: (error, stack) => [],
      ),
      filters: spellFilters.value,
      onRequiresConcentrationChanged: (requiresConcentration) {
        spellFilters.value = spellFilters.value.copyWith(
          requiresConcentrationSetter: () {
            return requiresConcentration;
          },
        );
      },
      onCanBeCastAsRitualChanged: (canBeCastAsRitual) {
        spellFilters.value = spellFilters.value.copyWith(
          canBeCastAsRitualSetter: () {
            return canBeCastAsRitual;
          },
        );
      },
      onRequiresVerbalComponentChanged: (requiresVerbalComponent) {
        spellFilters.value = spellFilters.value.copyWith(
          requiresVerbalComponentSetter: () {
            return requiresVerbalComponent;
          },
        );
      },
      onRequiresSomaticComponentChanged: (requiresSomaticComponent) {
        spellFilters.value = spellFilters.value.copyWith(
          requiresSomaticComponentSetter: () {
            return requiresSomaticComponent;
          },
        );
      },
      onRequiresMaterialComponentChanged: (requiresMaterialComponent) {
        spellFilters.value = spellFilters.value.copyWith(
          requiresMaterialComponentSetter: () {
            return requiresMaterialComponent;
          },
        );
      },
      onSelectedSchoolsChanged: (selectedSchools) {
        spellFilters.value = spellFilters.value.copyWith(
          selectedSchools: selectedSchools,
        );
      },
      onCastingTimeChanged: (castingTimeIds) {
        spellFilters.value = spellFilters.value.copyWith(
          castingTimeIds: castingTimeIds,
        );
      },
      onRangeChanged: (rangeIds) {
        spellFilters.value = spellFilters.value.copyWith(
          rangeIds: rangeIds,
        );
      },
      onDurationChanged: (durationIds) {
        spellFilters.value = spellFilters.value.copyWith(
          durationIds: durationIds,
        );
      },
      onSpellLevelChanged: (spellLevels) {
        spellFilters.value = spellFilters.value.copyWith(
          spellLevels: spellLevels,
        );
      },
      onSpellTypesChanged: (spellTypes) {
        spellFilters.value = spellFilters.value.copyWith(
          spellTypes: spellTypes,
        );
      },
    );
  }
}
