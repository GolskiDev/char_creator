import 'package:char_creator/features/character/character_repository.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common/widgets/default_async_id_page_builder.dart';
import '../features/character/character.dart';
import '../features/character/character_providers.dart';
import '../features/character/character_use_cases.dart';
import '../features/character/field.dart';
import '../features/notes/note.dart';
import 'edit_note_page.dart';

class CharacterPage extends HookConsumerWidget {
  const CharacterPage({
    super.key,
    required this.characterId,
  });

  final String characterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterAsync = ref.watch(characterByIdProvider(characterId));

    return DefaultAsyncIdPageBuilder<Character>(
      asyncValue: characterAsync,
      pageBuilder: (context, character) {
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
            title: const Text("Character Details"),
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
      },
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
      onWillAcceptWithDetails: (details) {
        // check if the note is coming from the same field
        final fromField = character.fields.firstWhereOrNull(
          (f) => f.notes.contains(details.data),
        );
        return fromField != null && fromField != field;
      },
      onAcceptWithDetails: (details) async {
        final note = details.data;
        final toField = field;

        final updatedCharacter = character.moveNoteBetweenFields(
          targetFieldName: toField.name,
          movedNoteId: note.id,
        );

        await ref.read(characterRepositoryProvider).updateCharacter(updatedCharacter);
      },
      builder: (context, candidateItems, rejectedItems) {
        final fieldName = Text(
          field.name,
          style: Theme.of(context).textTheme.titleLarge,
        );
        final newNoteChip = IconButton(
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.add),
          onPressed: () => _addNewNote(
            context,
            field,
            character,
          ),
        );
        final listOfNotes = SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [...notesWidgets, newNoteChip]
                .map(
                  (e) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: e,
                  ),
                )
                .toList(),
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
                      ],
                    ),
                  ),
                  listOfNotes,
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
                ],
              ),
            ),
            listOfNotes,
          ],
        );
      },
    );
  }

  void _addNewNote(BuildContext context, Field field, Character character) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteFormPage(
          onSavePressed: (context, ref, noteFormState) async{
            final updatedCharacter = character.addOrUpdateNoteInField(
              fieldName: field.name,
              note: Note.create(value: noteFormState.value),
            );
            await ref.read(characterRepositoryProvider).updateCharacter(updatedCharacter);
          },
        ),
      ),
    );
  }

  Widget _noteCard(
    BuildContext context,
    WidgetRef ref,
    Character character,
    Field field,
    Note note,
  ) {
    final child = Material(
      color: Colors.transparent,
      child: ActionChip.elevated(
        label: Text(
          note.value,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        onPressed: () => _onNotePressed(
          context,
          note,
          field,
          character,
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
          ),
          onSavePressed: (context, ref, updatedNote) async {
            final updatedCharacter = character.addOrUpdateNoteInField(
              fieldName: field.name,
              note: note.copyWith(value: updatedNote.value),
            );
            await ref.read(characterRepositoryProvider).updateCharacter(updatedCharacter);
          },
          onDeletePressed: (context, ref) async {
            final characterUseCases = ref.read(characterUseCasesProvider);
            await characterUseCases.deleteNoteInField(
              character: character,
              field: field,
              note: note,
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
              title: const Text('Add Field'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Field Name',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final characterUseCases =
                        ref.read(characterUseCasesProvider);
                    await characterUseCases.addNewFieldToCharacter(
                      character: character,
                      field: Field.create(
                        name: controller.text,
                        notes: [],
                      ),
                    );
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
      child: const Icon(Icons.add),
    );
  }
}
