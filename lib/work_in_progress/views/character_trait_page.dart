import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../note.dart';
import '../note_repository.dart';
import 'edit_trait_page.dart';

class CharacterTraitPage extends HookConsumerWidget {
  const CharacterTraitPage({
    required this.trait,
    super.key,
  });
  final Note trait;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterTraitRepository =
        ref.watch(characterTraitRepositoryProvider);
    final displayView = Scaffold(
      appBar: AppBar(
        title: Text(trait.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              characterTraitRepository.deleteTrait(trait.id);
              Navigator.of(context).pop();
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final newValue = await Navigator.of(context).push<String>(
                MaterialPageRoute<String>(
                  builder: (context) {
                    return TraitFormPage(
                      initialValue: TraitFormState(
                        value: trait.value,
                        tags: [],
                      ),
                    );
                  },
                ),
              );
              if (newValue != null) {
                _updateTrait(characterTraitRepository, trait, newValue);
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

  _updateTrait(
      CharacterTraitRepository repository, Note trait, String newValue) async {
    final updatedTrait = trait.copyWith(value: newValue);
    repository.updateTrait(updatedTrait);
  }
}
