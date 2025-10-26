import 'package:char_creator/features/5e/character/repository/character_repository.dart';
import 'package:char_creator/features/5e/game_system_view_model.dart';
import 'package:char_creator/features/5e/spells/filters/spell_model_filters_state.dart';
import 'package:char_creator/features/5e/spells/widgets/small_spell_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../character/models/character_5e_class_model_v1.dart';
import '../character/models/character_5e_model_v1.dart';
import 'spell_card_page.dart';
import 'utils/spell_utils.dart';
import 'view_models/spell_view_model.dart';
import 'widgets/add_to_character_menu.dart';
import 'widgets/spell_filter_drawer.dart';

class ListOfSpellsPage extends HookConsumerWidget {
  final String? targetCharacterId;
  const ListOfSpellsPage({
    this.targetCharacterId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allSpells = ref.watch(spellViewModelsProvider);
    final allCharactersAsync = ref.watch(charactersStreamProvider);

    final selectedCharacterId = useState<String?>(targetCharacterId);

    final List<Character5eModelV1> characters;
    switch (allCharactersAsync) {
      case AsyncValue(value: final List<Character5eModelV1> loadedCharacters):
        characters = loadedCharacters;
        break;
      default:
        characters = [];
        break;
    }

    final selectedCharacter = characters.firstWhereOrNull(
      (element) => element.id == selectedCharacterId.value,
    );

    final spellFilters = useState(
      SpellModelFiltersState(
        character: targetCharacterId != null ? selectedCharacter : null,
      ),
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

    addToCharacterWidgetBuilder(SpellViewModel spell) {
      final isSpellAdded = selectedCharacter != null &&
          selectedCharacter.knownSpells.contains(spell.id);
      return IconButton(
        icon: isSpellAdded
            ? const Icon(Symbols.person_check)
            : const Icon(Symbols.add),
        onPressed: () async {
          if (selectedCharacter != null) {
            Character5eModelV1 updatedCharacter;
            if (isSpellAdded) {
              updatedCharacter = selectedCharacter.removeSpellForCharacter(
                spellId: spell.id,
                onlyUnprepare: false,
              );
            } else {
              try {
                updatedCharacter = selectedCharacter.addSpellForCharacter(
                  spellId: spell.id,
                );
              } on MultipleClassesWithSpellFoundException catch (_) {
                final selectedClassId = await showDialog<String?>(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Select Class'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: selectedCharacter.classesStates.map(
                            (classState) {
                              final classModel = classState.classModel;
                              return RadioListTile<String>(
                                title: Text(classModel.className ?? ''),
                                value: classModel.id,
                                groupValue: selectedCharacterId.value,
                                onChanged: (value) {
                                  Navigator.of(context).pop(value);
                                },
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    );
                  },
                );
                if (selectedClassId == null) {
                  return;
                }
                updatedCharacter = selectedCharacter.addSpellForCharacter(
                  spellId: spell.id,
                  classId: selectedClassId,
                );
              }
            }
            final repository =
                await ref.read(characterRepositoryProvider.future);
            await repository?.updateCharacter(updatedCharacter);
          }
        },
      );
    }

    final isAddToCharacterEnabled = selectedCharacter != null;

    final searchController = useTextEditingController(
      text: spellFilters.value.searchText,
    );
    final searchFocusNode = useFocusNode(
      canRequestFocus: true,
    );

    // useListenable(searchFocusNode);

    final isSearchVisible =
        searchFocusNode.hasFocus || searchController.text.isNotEmpty;

    final isListMode = useState(false);

    final menuEntries = [
      // ViewMode
      MenuItemButton(
        leadingIcon: Icon(
          isListMode.value
              ? GameSystemViewModel.cardMode.icon
              : GameSystemViewModel.listMode.icon,
        ),
        child: Text(isListMode.value
            ? GameSystemViewModel.cardMode.name
            : GameSystemViewModel.listMode.name),
        onPressed: () {
          isListMode.value = !isListMode.value;
        },
      ),
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
          children: [
            TextField(
              focusNode: searchFocusNode,
              canRequestFocus: true,
              controller: searchController,
              onTap: () {
                if (!searchFocusNode.hasFocus) {
                  searchFocusNode.requestFocus();
                }
              },
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
                label: searchFocusNode.hasFocus
                    ? null
                    : Text(
                        'Spells',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                floatingLabelBehavior: FloatingLabelBehavior.never,
                suffixIcon: searchFocusNode.hasFocus
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          spellFilters.value = spellFilters.value.copyWith(
                            searchTextSetter: () => null,
                          );
                          searchController.clear();
                          searchFocusNode.unfocus();
                        },
                      )
                    : null,
              ),
            ),
          ],
        );
      },
    );

    return Scaffold(
      endDrawer: spellFilterDrawer(
        allSpells,
        characters,
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
      body: allSpells.when(
        data: (cantrips) {
          final filteredSpells =
              spellFilters.value.filterSpells(cantrips.map((e) => e).toList())
                ..sort(
                  (a, b) {
                    return a.spellLevel == b.spellLevel
                        ? a.name.compareTo(b.name)
                        : a.spellLevel.compareTo(b.spellLevel);
                  },
                );
          return SafeArea(
            child: GestureDetector(
              onScaleEnd: (details) {
                if (details.scaleVelocity < 0) {
                  isListMode.value = true;
                } else if (details.scaleVelocity > 0) {
                  isListMode.value = false;
                }
              },
              child: Builder(
                builder: (context) {
                  if (isListMode.value) {
                    return listView(
                      filteredSpells,
                      isAddToCharacterEnabled,
                      addToCharacterWidgetBuilder,
                    );
                  }
                  return gridView(
                    context,
                    filteredSpells,
                    isAddToCharacterEnabled,
                    addToCharacterWidgetBuilder,
                  );
                },
              ),
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

  ListView listView(
      List<SpellViewModel> filteredSpells,
      bool isAddToCharacterEnabled,
      IconButton Function(SpellViewModel spell) addToCharacterWidgetBuilder) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      itemCount: filteredSpells.length,
      itemBuilder: (context, index) {
        final shouldDisplayLevelSeparator = index == 0 ||
            filteredSpells[index].spellLevel !=
                filteredSpells[index - 1].spellLevel;
        final spellViewModel = filteredSpells[index];
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (shouldDisplayLevelSeparator) ...[
              Text(
                SpellUtils.spellLevelString(
                  spellViewModel.spellLevel,
                ),
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Divider(),
            ],
            Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: ListTile(
                leading: isAddToCharacterEnabled
                    ? addToCharacterWidgetBuilder(spellViewModel)
                    : null,
                title: Text(spellViewModel.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return SpellCardPage(
                          id: spellViewModel.id,
                          spellsFuture: Future.value(filteredSpells),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
    );
  }

  Widget gridView(
    BuildContext context,
    List<SpellViewModel> filteredSpells,
    bool isAddToCharacterEnabled,
    IconButton Function(SpellViewModel spell) addToCharacterWidgetBuilder,
  ) {
    final Map<int, List<SpellViewModel>> spellGroupedByLevel =
        filteredSpells.groupListsBy(
      (spell) => spell.spellLevel,
    );

    return CustomScrollView(
      cacheExtent: MediaQuery.of(context).size.height,
      slivers: [
        ...spellGroupedByLevel.entries
            .map(
              (listOfSpellLevel) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        SpellUtils.spellLevelString(listOfSpellLevel.key),
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  sliver: SliverGrid.builder(
                    itemCount: listOfSpellLevel.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 4,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final spellViewModel = listOfSpellLevel.value[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SpellCardPage(
                                    id: spellViewModel.id,
                                    spellsFuture: Future.value(filteredSpells),
                                  );
                                },
                              ),
                            );
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              SmallSpellWidget(
                                spell: spellViewModel,
                              ),
                              if (isAddToCharacterEnabled)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: addToCharacterWidgetBuilder(
                                        spellViewModel),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
            .expand((element) => element)
      ],
    );
  }

  SpellFilterDrawer spellFilterDrawer(
    AsyncValue<List<SpellViewModel>> allCantrips,
    List<Character5eModelV1> characters,
    ValueNotifier<SpellModelFiltersState> spellFilters,
  ) {
    return SpellFilterDrawer(
      allSpellModels: allCantrips.when(
        skipLoadingOnReload: true,
        data: (cantrips) => cantrips.toList(),
        loading: () => [],
        error: (error, stack) => [],
      ),
      characters: characters,
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
      onCharacterClassesChanged:
          (Set<ICharacter5eClassModelV1> characterClasses) {
        spellFilters.value = spellFilters.value.copyWith(
          characterClasses: characterClasses,
        );
      },
      onCharacterChanged: (character) {
        spellFilters.value = spellFilters.value.copyWith(
          characterSetter: () => character,
        );
      },
    );
  }
}
