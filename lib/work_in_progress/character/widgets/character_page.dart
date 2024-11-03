import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../notes/note.dart';
import '../../views/edit_note_page.dart';
import '../character.dart';
import '../character_repository.dart';
import '../field.dart';

class CharacterPage extends HookConsumerWidget {
  const CharacterPage({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterFieldWidgets = character.fields
        .map(
          (field) => _characterField(
            context,
            ref,
            character,
            field,
          ),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.chat,
            ),
            onPressed: () => context.go('/characters/${character.id}/chat'),
          ),
        ],
      ),
      floatingActionButton: _floatingActionButton(
        context,
        ref,
        character,
      ),
      body: ListView(
        children: characterFieldWidgets,
      ),
    );
  }

  Widget _characterField(
    BuildContext context,
    WidgetRef ref,
    Character character,
    Field field,
  ) {
    final notesWidgets = field.notes.map(
      (note) {
        return _noteCard(
          context,
          ref,
          character,
          field,
          note,
        );
      },
    ).toList();
    return DragTarget<Note>(
      onAcceptWithDetails: (details) {
        // move note from one field to another
        final note = details.data;
        // check Where the note is coming from
        final fromField = character.fields.firstWhereOrNull(
          (f) => f.notes.contains(note),
        );
        // check Where the note is going to
        final toField = character.fields.firstWhereOrNull(
          (f) => f == field,
        );
        if (fromField != null && toField != null) {
          final updatedFromField = fromField.copyWith(
            notes: fromField.notes.where((n) => n != note).toList(),
          );
          final updatedToField = toField.copyWith(
            notes: [...toField.notes, note],
          );
          final updatedFields = character.fields
              .map((f) => f == fromField
                  ? updatedFromField
                  : f == toField
                      ? updatedToField
                      : f)
              .toList();
          final updatedCharacter = character.copyWith(
            fields: updatedFields,
          );
          ref.read(characterRepositoryProvider).updateCharacter(
                updatedCharacter,
              );
        }
      },
      builder: (context, candidateItems, rejectedItems) {
        final fieldName = Text(
          field.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        );
        final newNoteButton = IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteFormPage(
                  onSavePressed: (context, ref, note) {
                    final updatedField = field.copyWith(
                      notes: [...field.notes, Note.create(value: note.value)],
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
        );
        final listOfFields = ScrollConfiguration(
          behavior: const ScrollBehavior().copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: notesWidgets,
            ),
          ),
        );
        if (candidateItems.isNotEmpty) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        fieldName,
                        Visibility(
                          visible: false,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: newNoteButton,
                        ),
                      ],
                    ),
                  ),
                  listOfFields,
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  child: const Center(
                    child: Text(
                      'Drop here',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  fieldName,
                  newNoteButton,
                ],
              ),
            ),
            listOfFields,
          ],
        );
      },
    );
  }

  Widget _noteCard(
    BuildContext context,
    WidgetRef ref,
    Character character,
    Field field,
    Note note,
  ) {
    final child = Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          _onNotePressed(
            context,
            note,
            field,
            character,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.value),
            ],
          ),
        ),
      ),
    );
    return LongPressDraggable<Note>(
      delay: const Duration(milliseconds: 200),
      data: note,
      feedback: child,
      childWhenDragging: Opacity(
        opacity: 0.5,
        child: child,
      ),
      child: child,
    );
  }

  void _onNotePressed(
      BuildContext context, Note note, Field field, Character character) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteFormPage(
          initialValue: TraitFormState(
            value: note.value,
            tags: [],
          ),
          onSavePressed: (context, ref, updatedNote) {
            final updatedField = field.copyWith(
              notes: field.notes
                  .map((n) =>
                      n == note ? Note.create(value: updatedNote.value) : n)
                  .toList(),
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
          onDeletePressed: (context, ref) {
            final updatedField = field.copyWith(
              notes: field.notes.where((n) => n != note).toList(),
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
