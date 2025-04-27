import 'package:char_creator/features/5e/character/models/character_5e_ability_scores.dart';
import 'package:char_creator/features/5e/character/models/character_5e_spell_slots.dart';
import 'package:char_creator/features/5e/character/widgets/character_classes_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../game_system_view_model.dart';
import '../spells/view_models/spell_view_model.dart';
import 'models/character_5e_model_v1.dart';
import 'repository/character_repository.dart';
import 'widgets/character_ability_scores_widget.dart';
import 'widgets/character_other_props_widget.dart';
import 'widgets/character_skills_widget.dart';
import 'widgets/character_spells_slots_widget.dart';
import 'widgets/conditions_5e_widget.dart';
import 'widgets/grouped_spells_widget.dart';

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
      "spells": ExpansionPanel(
        isExpanded: openedExpansionPanelsIndexes.value.contains("spells"),
        headerBuilder: (context, isExpanded) {
          return ListTile(
            leading: Icon(GameSystemViewModel.spells.icon),
            title: Text(GameSystemViewModel.spells.name),
            trailing: isExpanded
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      context.go(
                        '/characters/${character.id}/addSpells',
                      );
                    },
                  )
                : null,
          );
        },
        body: GroupedSpellsWidget(
          characterSpells: characterSpells,
        ),
      ),
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
      if (character.spellSlots != null) ...{
        "spellSlots": ExpansionPanel(
          isExpanded: openedExpansionPanelsIndexes.value.contains("spellSlots"),
          headerBuilder: (context, isExpanded) {
            return ListTile(
              leading: Icon(GameSystemViewModel.spellSlots.icon),
              title: Text(GameSystemViewModel.spellSlots.name),
            );
          },
          body: CharacterSpellsSlotsWidget.maxAndCurrent(
            spellSlots: character.spellSlots!,
            onChanged: (updatedSpellSlots) {
              final updatedCharacter = character.copyWith(
                spellSlots: updatedSpellSlots,
              );
              ref
                  .read(characterRepositoryProvider)
                  .updateCharacter(updatedCharacter);
            },
          ),
        ),
      }
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (character.classesStates.isNotEmpty) ...[
              _characterClassesWidget(character),
              const Divider(),
            ],
            if (character.others != null) ...[
              CharacterOtherPropsWidget(
                characterOtherProps: character.others!,
                onChanged: (updatedOtherProps) {
                  final updatedCharacter = character.copyWith(
                    others: updatedOtherProps,
                  );
                  ref
                      .read(characterRepositoryProvider)
                      .updateCharacter(updatedCharacter);
                },
              ),
              const Divider(),
            ],
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                final panelKey =
                    mapOfExpansionPanels.keys.elementAt(panelIndex);
                if (openedExpansionPanelsIndexes.value.contains(panelKey)) {
                  openedExpansionPanelsIndexes.value =
                      openedExpansionPanelsIndexes.value
                          .where((key) => key != panelKey)
                          .toList();
                } else {
                  openedExpansionPanelsIndexes.value = [
                    ...openedExpansionPanelsIndexes.value,
                    panelKey,
                  ];
                }
              },
              children: expansionPanels,
            ),
            if (character.abilityScores == null) ...[
              const Divider(),
              ListTile(
                title: Text('Add ${GameSystemViewModel.abilityScores.name}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final updatedCharacter = character.copyWith(
                      abilityScores: Character5eAbilityScores.empty(),
                    );
                    ref
                        .read(characterRepositoryProvider)
                        .updateCharacter(updatedCharacter);
                  },
                ),
              ),
            ],
            if (character.spellSlots == null) ...[
              const Divider(),
              ListTile(
                title: Text('Add ${GameSystemViewModel.spellSlots.name}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final updatedCharacter = character.copyWith(
                      spellSlots: Character5eSpellSlots.empty(),
                    );
                    ref
                        .read(characterRepositoryProvider)
                        .updateCharacter(updatedCharacter);
                  },
                ),
              ),
            ],
          ],
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
