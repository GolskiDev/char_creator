import 'package:char_creator/work_in_progress/character/character_providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:collection/collection.dart';

import '../../notes/note.dart';
import '../../views/edit_note_page.dart';
import '../character.dart';
import '../character_repository.dart';
import '../field.dart';

class CharacterPage extends HookConsumerWidget {
  const CharacterPage({super.key, required this.characterId});

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(
      charactersProvider,
    );
    switch (charactersAsync) {
      case AsyncError():
        return const Scaffold(
          body: Center(
            child: Text('An error occurred'),
          ),
        );
      case AsyncData(value: final List<Character> characters):
        final character = characters.firstWhereOrNull(
          (character) => character.id == characterId,
        );
        return _characterPage(context, ref, character);
      default:
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
    }
  }

  Widget _characterPage(context, ref, character) {
    return Scaffold(
      floatingActionButton: _floatingActionButton(
        context,
        ref,
        character,
      ),
      body: ListView.builder(
        itemCount: character.fields.length,
        itemBuilder: (context, index) {
          final field = character.fields[index];
          return _characterField(
            context,
            ref,
            character,
            field,
          );
        },
      ),
    );
  }

  Widget _characterField(
      BuildContext context, WidgetRef ref, Character character, Field field) {
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

  _floatingActionButton(
    BuildContext context,
    WidgetRef ref,
    Character character,
  ) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return AlertDialog(
              title: Text('Add Field'),
              content: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Field Name',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final newField = Field(
                      name: controller.text,
                      notes: [],
                    );
                    final updatedFields = [...character.fields, newField];
                    final updatedCharacter = character.copyWith(
                      fields: updatedFields,
                    );
                    ref
                        .read(characterRepositoryProvider)
                        .updateCharacter(updatedCharacter);
                    Navigator.of(context).pop();
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
      child: Icon(Icons.add),
    );
  }
}
