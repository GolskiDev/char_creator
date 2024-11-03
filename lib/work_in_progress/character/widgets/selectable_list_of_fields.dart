import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notes/note.dart';
import '../character.dart';

class SelectableListOfFields extends HookConsumerWidget {
  const SelectableListOfFields({
    super.key,
    required this.character,
    required this.onNotePressed,
    required this.selectedNotesIds,
  });

  final Character character;
  final List<String> selectedNotesIds;
  final Function(Note pressedNote) onNotePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fieldsWidgets = character.fields.map(
      (field) {
        final notesWidgets = field.notes.map(
          (note) {
            final isSelected = selectedNotesIds.contains(note.id);
            return ChoiceChip(
              label: Text(note.value),
              selected: isSelected,
              onSelected: (_) {
                onNotePressed(note);
              },
            );
          },
        ).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              field.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: notesWidgets,
            ),
          ],
        );
      },
    ).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: fieldsWidgets,
    );
  }
}
