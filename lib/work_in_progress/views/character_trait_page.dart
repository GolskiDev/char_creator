import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character_trait.dart';
import '../character_trait_repository.dart';
import 'edit_trait_page.dart';

class CharacterTraitPage extends HookConsumerWidget {
  const CharacterTraitPage({
    required this.trait,
    super.key,
  });
  final SingleValueCharacterTrait trait;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayView = Scaffold(
      appBar: AppBar(
        title: Text(trait.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              CharacterTraitRepository().deleteTrait(trait.id);
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final newValue = await Navigator.of(context).push<String>(
                MaterialPageRoute<String>(
                  builder: (context) {
                    return EditStringPage(initialValue: trait.value);
                  },
                ),
              );
              if (newValue != null) {
                _updateTrait(trait, newValue);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(trait.value),
      ),
    );

    return displayView;
  }

  _updateTrait(SingleValueCharacterTrait trait, String newValue) async {
    final CharacterTraitRepository repository = CharacterTraitRepository();
    final updatedTrait = trait.copyWith(value: newValue);
    repository.updateTrait(updatedTrait);
  }
}
