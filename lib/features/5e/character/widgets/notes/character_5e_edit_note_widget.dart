import 'package:spells_and_tools/features/5e/character/models/character_5e_note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Character5eEditNoteWidget extends HookConsumerWidget {
  final Character5eNote? note;
  final ValueChanged<Character5eNote> onUpdate;
  final Function()? onDelete;

  const Character5eEditNoteWidget({
    super.key,
    required this.note,
    required this.onUpdate,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteState = useState(
      note ?? Character5eNote.empty(),
    );
    final noteController = useTextEditingController(
      text: noteState.value.content,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Flexible(
          child: TextField(
            controller: noteController,
            expands: true,
            maxLines: null,
            minLines: null,
            onChanged: (value) {
              noteState.value = noteState.value.copyWith(content: value);
            },
            textAlignVertical: TextAlignVertical.top,
            decoration: const InputDecoration(
              hintText: 'Enter your note here...',
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 8,
          children: [
            if (note != null && onDelete != null)
              Flexible(
                child: TextButton(
                  onPressed: () async {
                    final bool? shouldDelete = await showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Delete Note'),
                          content: const Text(
                              'Are you sure you want to delete this note?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                onDelete!();
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                    if (shouldDelete == true) {
                      onDelete!();
                    }
                  },
                  child: const Text('Delete'),
                ),
              ),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  onUpdate(noteState.value);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
