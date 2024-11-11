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
          Field.create(
            name: 'Race',
            notes: [],
          ),
          Field.create(
            name: 'Skills',
            notes: [],
          ),
          Field.create(
            name: 'Background',
            notes: [],
          ),
          Field.create(
            name: 'Equipment',
            notes: [],
          ),
          Field.create(
            name: 'Spells',
            notes: [],
          ),
        ],
      ),
    );
  }

  Future<void> deleteNoteInField({
    required Character character,
    required Field field,
    required Note note,
  }) async {
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

    await _characterRepository.updateCharacter(updatedCharacter);
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
