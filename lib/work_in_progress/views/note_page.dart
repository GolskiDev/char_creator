import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notes/note.dart';
import '../notes/note_repository.dart';
import 'edit_note_page.dart';

class NotePage extends HookConsumerWidget {
  const NotePage({
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
              if (!context.mounted) return;

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return NoteFormPage(
                      initialValue: TraitFormState(
                        value: trait.value,
                      ),
                      onSavePressed: (context, ref, formState) async {
                        if (formState.value.isNotEmpty) {
                          final newNote = Note.create(value: formState.value);
                          await characterTraitRepository.updateTrait(
                            newNote,
                          );
                        }
                      },
                    );
                  },
                ),
              );
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
}
