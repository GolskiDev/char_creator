import 'package:spells_and_tools/features/5e/character/models/character_5e_note.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'character_5e_edit_note_widget.dart';

class Character5eNoteWidget extends HookConsumerWidget {
  final Character5eNote note;
  final ValueChanged<Character5eNote> onUpdate;
  final Function()? onDelete;

  const Character5eNoteWidget({
    required this.note,
    required this.onUpdate,
    required this.onDelete,
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(note.content.isEmpty ? 'Empty note' : note.content),
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Edit Note'),
              content: Character5eEditNoteWidget(
                note: note,
                onUpdate: (note) {
                  onUpdate(note);
                  Navigator.of(context).pop();
                },
                onDelete: () {
                  if (onDelete != null) {
                    onDelete!();
                  }
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        );
      },
    );
  }
}
