import 'package:char_creator/features/5e/character/widgets/character_classes_widget.dart';
import 'package:char_creator/features/5e/character/widgets/notes/character_5e_note_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../game_system_view_model.dart';
import '../spells/view_models/spell_view_model.dart';
import 'models/character_5e_model_v1.dart';
import 'models/character_5e_spell_slots.dart';
import 'repository/character_repository.dart';
import 'widgets/character_ability_scores_widget.dart';
import 'widgets/character_skills_widget.dart';
import 'widgets/conditions_5e_widget.dart';
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

    final characterSpells = spellViewModels
        .where((spell) => character.knownSpells.contains(spell.id))
        .toList();

    final openedExpansionPanelsIndexes = useState<List<String>>([]);

    final mapOfExpansionPanels = {
      if (character.abilityScores != null) ...{
        "abilityScores": ExpansionPanel(
          isExpanded:
              openedExpansionPanelsIndexes.value.contains("abilityScores"),
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(GameSystemViewModel.abilityScores.icon),
              title: Text(GameSystemViewModel.abilityScores.name),
            );
          },
          body: CharacterAbilityScoresWidget.editing(
            abilityScores: character.abilityScores!,
            onChanged: (updatedAbilityScores) {
              final updatedCharacter = character.copyWith(
                abilityScores: updatedAbilityScores,
              );
              ref
                  .read(characterRepositoryProvider)
                  .updateCharacter(updatedCharacter);
            },
          ),
        ),
      },
      if (character.character5eSkills != null &&
          character.abilityScores != null) ...{
        "skills": ExpansionPanel(
          isExpanded: openedExpansionPanelsIndexes.value.contains("skills"),
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(GameSystemViewModel.skills.icon),
              title: Text(GameSystemViewModel.skills.name),
            );
          },
          body: CharacterSkillsWidget.editing(
            skills: character.character5eSkills!,
            abilityScores: character.abilityScores!,
            onChanged: (updatedSkills) {
              final updatedCharacter = character.copyWith();
              ref
                  .read(characterRepositoryProvider)
                  .updateCharacter(updatedCharacter);
            },
          ),
        )
      },
      if (character.conditions != null) ...{
        "classes": ExpansionPanel(
          isExpanded: openedExpansionPanelsIndexes.value.contains("classes"),
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(GameSystemViewModel.conditions.icon),
              title: Text(GameSystemViewModel.conditions.name),
            );
          },
          body: Conditions5eWidget(
            conditions: character.conditions!,
            onChanged: (updatedConditions) {
              final updatedCharacter = character.copyWith(
                conditions: updatedConditions,
              );
              ref
                  .read(characterRepositoryProvider)
                  .updateCharacter(updatedCharacter);
            },
          ),
        ),
      },
    };

    final expansionPanels = mapOfExpansionPanels.values.toList();

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
      body: SingleChildScrollView(
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
                        await ref
                            .read(characterRepositoryProvider)
                            .updateCharacter(updatedCharacter);
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
                                await ref
                                    .read(characterRepositoryProvider)
                                    .updateCharacter(updatedCharacter);
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
                              await ref
                                  .read(characterRepositoryProvider)
                                  .updateCharacter(updatedCharacter);
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
                              await ref
                                  .read(characterRepositoryProvider)
                                  .updateCharacter(updatedCharacter);
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Builder(
                          builder: (context) {
                            return GroupedSpellsWidget(
                              characterSpells: characterSpells,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
              ...character.notes.notes.entries.map(
                (e) => Card(
                  clipBehavior: Clip.antiAlias,
                  child: Character5eNoteWidget(
                    note: e.value,
                    onUpdate: (value) {
                      final updatedNotes = character.notes.copyWith(
                        notes: {
                          ...character.notes.notes,
                          e.key: value,
                        },
                      );
                      final updatedCharacter = character.copyWith(
                        notes: updatedNotes,
                      );
                      ref
                          .read(characterRepositoryProvider)
                          .updateCharacter(updatedCharacter);
                    },
                    onDelete: () {
                      final updatedNotes = character.notes.copyWith(
                        notes: {
                          ...character.notes.notes,
                        }..remove(e.key),
                      );
                      final updatedCharacter = character.copyWith(
                        notes: updatedNotes,
                      );
                      ref
                          .read(characterRepositoryProvider)
                          .updateCharacter(updatedCharacter);
                    },
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Character5eCreateNoteWidget(
                  notes: character.notes,
                  onUpdate: (updatedNotes) {
                    final updatedCharacter = character.copyWith(
                      notes: updatedNotes,
                    );
                    ref
                        .read(characterRepositoryProvider)
                        .updateCharacter(updatedCharacter);
                  },
                ),
              ),
              // if (character.others != null) ...[
              //   CharacterOtherPropsWidget(
              //     characterOtherProps: character.others!,
              //     onChanged: (updatedOtherProps) {
              //       final updatedCharacter = character.copyWith(
              //         others: updatedOtherProps,
              //       );
              //       ref
              //           .read(characterRepositoryProvider)
              //           .updateCharacter(updatedCharacter);
              //     },
              //   ),
              //   const Divider(),
              // ],
              // ExpansionPanelList(
              //   expansionCallback: (panelIndex, isExpanded) {
              //     final panelKey =
              //         mapOfExpansionPanels.keys.elementAt(panelIndex);
              //     if (openedExpansionPanelsIndexes.value.contains(panelKey)) {
              //       openedExpansionPanelsIndexes.value =
              //           openedExpansionPanelsIndexes.value
              //               .where((key) => key != panelKey)
              //               .toList();
              //     } else {
              //       openedExpansionPanelsIndexes.value = [
              //         ...openedExpansionPanelsIndexes.value,
              //         panelKey,
              //       ];
              //     }
              //   },
              //   children: expansionPanels,
              // ),
              // if (character.abilityScores == null) ...[
              //   const Divider(),
              //   ListTile(
              //     title: Text('Add ${GameSystemViewModel.abilityScores.name}'),
              //     trailing: IconButton(
              //       icon: const Icon(Icons.add),
              //       onPressed: () {
              //         final updatedCharacter = character.copyWith(
              //           abilityScores: Character5eAbilityScores.empty(),
              //         );
              //         ref
              //             .read(characterRepositoryProvider)
              //             .updateCharacter(updatedCharacter);
              //       },
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  _characterClassesWidget(Character5eModelV1 character) {
    final classes = character.classesStates
        .map((classState) => classState.classModel)
        .toList();
    final classesWidget = CharacterClassesWidget.viewing(
      selectedClasses: classes.toSet(),
    );
    final title = Text('Classes');
    if (classes.length <= 3) {
      return ListTile(
        title: title,
        trailing: classesWidget,
      );
    } else {
      return ListTile(
        title: title,
        subtitle: classesWidget,
      );
    }
  }
}
