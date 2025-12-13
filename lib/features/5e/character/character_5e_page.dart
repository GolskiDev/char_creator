import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:spells_and_tools/features/5e/character/widgets/character_stats_widget.dart';
import 'package:spells_and_tools/features/5e/character/widgets/notes/character_5e_note_widget.dart';

import '../game_system_view_model.dart';
import '../spells/view_models/spell_view_model.dart';
import '../spells/view_models/spell_view_models_provider.dart';
import 'models/character_5e_model_v1.dart';
import 'models/character_5e_spell_slots.dart';
import 'repository/character_repository.dart';
import 'widgets/grouped_spells_widget.dart';
import 'widgets/notes/character_5e_create_note_widget.dart';
import 'widgets/spell_slots/character_current_spell_slots_widget.dart';
import 'widgets/spell_slots/character_edit_spell_slots_widget.dart';

class Character5ePage extends HookConsumerWidget {
  final String characterId;

  const Character5ePage({
    required this.characterId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersStreamProvider);
    final spellsAsync = ref.watch(spellViewModelsProvider);

    final List<SpellViewModel> spellViewModels;
    switch (spellsAsync) {
      case AsyncValue(value: final List<SpellViewModel> value):
        spellViewModels = value;
        break;
      default:
        spellViewModels = [];
    }

    final Character5eModelV1 character;
    switch (charactersAsync) {
      case AsyncValue(value: final List<Character5eModelV1> characters):
        final foundCharacter = characters
            .firstWhereOrNull((character) => character.id == characterId);
        if (foundCharacter == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Character'),
            ),
            body: Center(
              child: Text('Character not found'),
            ),
          );
        }
        character = foundCharacter;
      default:
        return Scaffold(
          appBar: AppBar(
            title: Text('Character'),
          ),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }

    final page = useState(
      0,
    );

    final pageController = usePageController(
      initialPage: page.value,
    );

    useEffect(
      () {
        void pageListener() {
          if (pageController.page != null) {
            final newPage = pageController.page!.round();
            if (newPage != page.value) {
              page.value = newPage;
            }
          }
        }

        pageController.addListener(pageListener);
        return () => pageController.removeListener(pageListener);
      },
      [pageController],
    );

    final characterSpells = spellViewModels
        .where((spell) => character.knownSpells.contains(spell.id))
        .toList();

    final spellPage = SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 8,
          children: [
            if (character.spellSlots == null ||
                character.spellSlots!.areSpellSlotsEmpty) ...[
              Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(GameSystemViewModel.spellSlots.icon),
                  title: Text('Add ${GameSystemViewModel.spellSlots.name}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () async {
                      final updatedCharacter = character.copyWith(
                        spellSlots: Character5eSpellSlots.empty(),
                      );
                      final repository =
                          await ref.read(characterRepositoryProvider.future);
                      await repository?.updateCharacter(updatedCharacter);
                      if (!context.mounted) {
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CharacterEditSpellSlotsWidget(
                            spellSlots: updatedCharacter.spellSlots!,
                            onChanged: (updatedSpellSlots) async {
                              final updatedCharacter = character.copyWith(
                                spellSlots: updatedSpellSlots,
                              );
                              await repository
                                  ?.updateCharacter(updatedCharacter);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ] else ...[
              Card(
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CharacterEditSpellSlotsWidget(
                          spellSlots: character.spellSlots!,
                          onChanged: (updatedSpellSlots) async {
                            final updatedCharacter = character.copyWith(
                              spellSlots: updatedSpellSlots,
                            );
                            final repository = await ref
                                .read(characterRepositoryProvider.future);
                            await repository?.updateCharacter(updatedCharacter);
                          },
                        ),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(GameSystemViewModel.spellSlots.icon),
                        title: Text(GameSystemViewModel.spellSlots.name),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CharacterCurrentSpellSlotsWidget(
                          spellSlots: character.spellSlots!,
                          onChanged: (updatedSpellSlots) async {
                            final updatedCharacter = character.copyWith(
                              spellSlots: updatedSpellSlots,
                            );
                            final repository = await ref
                                .read(characterRepositoryProvider.future);
                            await repository?.updateCharacter(updatedCharacter);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Card(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (characterSpells.isEmpty)
                    ListTile(
                      leading: Icon(GameSystemViewModel.spells.icon),
                      title: Text('Add ${GameSystemViewModel.spells.name}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.go(
                            '/characters/${character.id}/addSpells',
                          );
                        },
                      ),
                    ),
                  if (characterSpells.isNotEmpty)
                    ListTile(
                      leading: Icon(GameSystemViewModel.spells.icon),
                      title: Text(
                        GameSystemViewModel.spells.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.go(
                            '/characters/${character.id}/addSpells',
                          );
                        },
                      ),
                    ),
                  if (characterSpells.isNotEmpty)
                    Builder(
                      builder: (context) {
                        return GroupedSpellsWidget(
                          characterSpells: characterSpells,
                        );
                      },
                    ),
                ],
              ),
            ),
            ...character.notes.notes.entries.map(
              (e) => Card(
                clipBehavior: Clip.antiAlias,
                child: Character5eNoteWidget(
                  note: e.value,
                  onUpdate: (value) async {
                    final updatedNotes = character.notes.copyWith(
                      notes: {
                        ...character.notes.notes,
                        e.key: value,
                      },
                    );
                    final updatedCharacter = character.copyWith(
                      notes: updatedNotes,
                    );
                    final repository =
                        await ref.read(characterRepositoryProvider.future);
                    await repository?.updateCharacter(updatedCharacter);
                  },
                  onDelete: () async {
                    final updatedNotes = character.notes.copyWith(
                      notes: {
                        ...character.notes.notes,
                      }..remove(e.key),
                    );
                    final updatedCharacter = character.copyWith(
                      notes: updatedNotes,
                    );
                    final repository =
                        await ref.read(characterRepositoryProvider.future);
                    await repository?.updateCharacter(updatedCharacter);
                  },
                ),
              ),
            ),
            SafeArea(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Character5eCreateNoteWidget(
                  notes: character.notes,
                  onUpdate: (updatedNotes) async {
                    final updatedCharacter = character.copyWith(
                      notes: updatedNotes,
                    );
                    final repository =
                        await ref.read(characterRepositoryProvider.future);
                    await repository?.updateCharacter(updatedCharacter);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    final statsPage = CharacterStatsWidget(
      character: character,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.go(
                '/characters/${character.id}/edit',
              );
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          spellPage,
          statsPage,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (value) => {
          pageController.animateToPage(
            value,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
          page.value = value,
        },
        selectedIndex: page.value,
        destinations: [
          NavigationDestination(
            icon: Icon(GameSystemViewModel.spells.icon),
            label: GameSystemViewModel.spells.name,
          ),
          NavigationDestination(
            icon: Icon(GameSystemViewModel.abilityScores.icon),
            label: GameSystemViewModel.abilityScores.name,
          ),
        ],
      ),
    );
  }
}
