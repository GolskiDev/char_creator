import 'package:char_creator/features/5e/character/widgets/character_classes_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../spells/view_models/spell_view_model.dart';
import 'models/character_5e_model_v1.dart';
import 'repository/character_repository.dart';
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

    final spellOpenedState = useState(false);

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
          children: [
            if (character.classesStates.isNotEmpty) ...[
              _characterClassesWidget(character),
              const Divider(),
            ],
            ExpansionPanelList(
              expansionCallback: (panelIndex, isExpanded) {
                spellOpenedState.value = !spellOpenedState.value;
              },
              children: [
                ExpansionPanel(
                  isExpanded: spellOpenedState.value,
                  headerBuilder: (context, isExpanded) {
                    return ListTile(
                      leading: const Icon(Symbols.magic_button),
                      title: Text('Spells'),
                      trailing: isExpanded
                          ? IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {},
                            )
                          : null,
                    );
                  },
                  body: GroupedSpellsWidget(
                    characterSpells: characterSpells,
                  ),
                ),
              ],
            ),
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
