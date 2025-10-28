import 'package:spells_and_tools/features/5e/game_system_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../models/character_5e_note.dart';
import 'character_5e_edit_note_widget.dart';

class Character5eCreateNoteWidget extends HookConsumerWidget {
  final Character5eNotes notes;
  final ValueChanged<Character5eNotes> onUpdate;

  const Character5eCreateNoteWidget({
    super.key,
    required this.notes,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: Icon(
        GameSystemViewModel.note.icon,
      ),
      title: Text('Add ${GameSystemViewModel.note.name}'),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Create Note'),
                content: Character5eEditNoteWidget(
                  note: null,
                  onUpdate: (note) {
                    final notes = Character5eNotes(
                      notes: {
                        ...this.notes.notes,
                        note.id: note,
                      },
                    );
                    onUpdate(notes);
                    Navigator.of(context).pop();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
