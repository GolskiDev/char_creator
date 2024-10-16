import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notes/note.dart';
import '../views/edit_note_page.dart';
import 'character.dart';
import 'character_repository.dart';
import 'field.dart';

class CharacterWidget extends HookConsumerWidget {
  const CharacterWidget({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: character.fields.length,
      itemBuilder: (context, index) {
        final field = character.fields[index];
        return _characterField(context, ref, field);
      },
    );
  }

  Widget _characterField(BuildContext context, WidgetRef ref, Field field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                field.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NoteFormPage(
                        onSavePressed: (context, ref, note) {
                          final updatedField = field.copyWith(
                            notes: [
                              ...field.notes,
                              Note.create(value: note.value)
                            ],
                          );
                          final updatedFields = character.fields
                              .map((f) => f == field ? updatedField : f)
                              .toList();
                          final updatedCharacter = character.copyWith(
                            fields: updatedFields,
                          );
                          ref.read(characterRepositoryProvider).updateCharacter(
                                updatedCharacter,
                              );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          }),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: field.notes.map((note) => _noteCard(note)).toList(),
            ),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _noteCard(Note note) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.id),
            Text(note.value),
          ],
        ),
      ),
    );
  }
}
