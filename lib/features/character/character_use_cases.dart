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

  Future<void> addNoteToField({
    required Character character,
    required Field field,
    required Note note,
  }) async {
    final updatedField = field.copyWith(
      notes: [...field.notes, note],
    );

    final updatedFields = character.fields
        .map((f) => f.name == field.name ? updatedField : f)
        .toList();

    return _characterRepository.updateCharacter(
      character.copyWith(fields: updatedFields),
    );
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
}
