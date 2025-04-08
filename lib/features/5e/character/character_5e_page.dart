import 'package:char_creator/features/5e/character/widgets/grouped_spells_widget.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../spells/view_models/spell_view_model.dart';
import 'models/character_5e_model.dart';
import 'repository/character_repository.dart';
import 'widgets/character_sheet_widget.dart';

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

    final Character5eModel? character;
    switch (charactersAsync) {
      case AsyncValue(value: final List<Character5eModel> characters):
        character = characters
            .firstWhereOrNull((character) => character.id == characterId);
        if (character == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Character'),
            ),
            body: Center(
              child: Text('Character not found'),
            ),
          );
        }
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
        .where((spell) => character!.spellIds.contains(spell.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Column(
        children: [
          // text buttton open character sheet widget
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CharacterSheetWidget(),
                ),
              );
            },
            child: const Text('Open Character Sheet'),
          ),
          Flexible(
            child: GroupedSpellsWidget(
              characterSpells: characterSpells,
            ),
          ),
        ],
      ),
    );
  }
}
