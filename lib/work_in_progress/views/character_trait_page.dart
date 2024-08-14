import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character_trait.dart';
import '../character_trait_repository.dart';

class CharacterTraitPage extends HookConsumerWidget {
  const CharacterTraitPage({
    required this.trait,
    super.key,
  });
  final SingleValueCharacterTrait trait;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = useState(false);
    final textController = useTextEditingController(text: trait.value);

    final displayView = Scaffold(
      appBar: AppBar(
        title: Text(trait.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              isEdit.value = true;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(trait.value),
      ),
    );

    final editView = Scaffold(
      appBar: AppBar(
        title: Text(trait.id),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              isEdit.value = false;
              _updateTrait(trait, textController.text);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textController,
        ),
      ),
    );

    return isEdit.value ? editView : displayView;
  }

  _updateTrait(SingleValueCharacterTrait trait, String newValue) async {
    final CharacterTraitRepository repository = CharacterTraitRepository();
    final updatedTrait = trait.copyWith(value: newValue);
    repository.updateTrait(updatedTrait);
  }
}
