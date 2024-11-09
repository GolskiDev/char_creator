import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notes/note.dart';
import 'character.dart';
import 'character_repository.dart';
import 'field.dart';

final characterUseCasesProvider = Provider(
  (ref) {
    final characterRepository = ref.watch(characterRepositoryProvider);
    return CharacterUseCases(
      characterRepository: characterRepository,
    );
  },
);

class CharacterUseCases {
  final CharacterRepository _characterRepository;

  CharacterUseCases({
    required CharacterRepository characterRepository,
  }) : _characterRepository = characterRepository;

  Future<void> createNewCharacter() {
    return _characterRepository.saveCharacter(
      Character.create(
        fields: [
          Field.create(
            name: 'Name',
            notes: [],
          ),
          Field.create(
            name: 'Class',
            notes: [],
          ),
        ],
      ),
    );
  }

  Future<void> addOrUpdateNoteInField({
    required Character character,
    required Field field,
    required Note note,
  }) async {
    final isNoteInTheField = field.notes.any((n) => n.id == note.id);

    final Field updatedField;
    if (isNoteInTheField) {
      final updatedNotes =
          field.notes.map((n) => n == note ? note : n).toList();
      updatedField = field.copyWith(notes: updatedNotes);
    } else {
      final updatedNotes = [...field.notes, note];
      updatedField = field.copyWith(notes: updatedNotes);
    }

    final updatedCharacter = character.copyWith(
      fields:
          character.fields.map((f) => f == field ? updatedField : f).toList(),
    );

    return _characterRepository.updateCharacter(updatedCharacter);
  }

  Future<void> deleteNoteInField({
    required Character character,
    required Field field,
    required Note note,
  }) {
    final isNoteInTheField = field.notes.any((n) => n.id == note.id);

    if (!isNoteInTheField) {
      throw Exception('Note not found in field');
    }

    final updatedNotes = field.notes.where((n) => n != note).toList();

    final updatedField = field.copyWith(notes: updatedNotes);

    final updatedCharacter = character.copyWith(
      fields:
          character.fields.map((f) => f == field ? updatedField : f).toList(),
    );

    return _characterRepository.updateCharacter(updatedCharacter);
  }

  Future<void> moveNoteBetweenFields({
    required Character character,
    required Field targetField,
    required Note note,
  }) async {
    //

    final fromField = character.fields.firstWhereOrNull(
      (field) => field.notes.any((note) => note.id == note.id),
    );

    if (fromField == null) {
      throw Exception('Note not found in any field');
    }

    //checkIfToFieldExists
    if (!character.fields.any((field) => field.name == targetField.name)) {
      throw Exception('Target Field does not exist in character');
    }

    final fromFieldIndex = character.fields.indexOf(fromField);
    final toFieldIndex = character.fields.indexOf(targetField);

    if (fromFieldIndex == toFieldIndex) {
      return;
    }

    final fromFieldNotes = fromField.notes.toList();
    final toFieldNotes = targetField.notes.toList();

    fromFieldNotes.remove(note);
    toFieldNotes.add(note);

    final updatedFields = character.fields.toList();
    updatedFields[fromFieldIndex] = fromField.copyWith(notes: fromFieldNotes);
    updatedFields[toFieldIndex] = targetField.copyWith(notes: toFieldNotes);

    return _characterRepository.updateCharacter(
      character.copyWith(fields: updatedFields),
    );
  }

  Future<void> addNewFieldToCharacter({
    required Character character,
    required Field field,
  }) async {
    try {
      final updatedFields = [...character.fields, field];
      final updatedCharacter = character.copyWith(fields: updatedFields);
      await _characterRepository.updateCharacter(updatedCharacter);
    } catch (e) {
      return;
    }
  }
}
