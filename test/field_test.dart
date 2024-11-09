// field cannot store 2 notes with the same id

import 'package:char_creator/features/character/field.dart';
import 'package:char_creator/features/notes/note.dart';
import 'package:test/test.dart';

void main() {
  test(
    'field cannot be created with 2 notes with the same id',
    () {
      final note1 = Note.create(
        value: 'Note 1',
      );

      createFieldWithDuplicatedNote() => Field.create(
            name: '_',
            notes: [
              note1,
              note1,
            ],
          );

      expect(createFieldWithDuplicatedNote, throwsA(isA<Exception>()));
    },
  );

  test(
    'field cannot be copiedWith with 2 notes with the same id',
    () {
      final note1 = Note.create(
        value: 'Note 1',
      );

      createFieldWithDuplicatedNote() => Field.create(
            name: '_',
            notes: [
              note1,
              note1,
            ],
          );

      expect(
        createFieldWithDuplicatedNote,
        throwsA(
          isA<Exception>(),
        ),
      );
    },
  );
}
