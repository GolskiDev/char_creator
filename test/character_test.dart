import 'package:char_creator/features/character/character.dart';
import 'package:char_creator/features/character/field.dart';
import 'package:char_creator/features/notes/note.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Character Class Tests',
    () {
      test(
        'You cannot create character with two fields with the same name',
        () {
          // Given
          final field1 =
              Field.create(name: 'name', notes: [Note.create(value: "John")]);
          final field2 =
              Field.create(name: 'name', notes: [Note.create(value: "Doe")]);
          final fields = [field1, field2];

          createCharacter() => Character.create(fields: fields);

          expect(
            createCharacter,
            throwsA(
              isA<Exception>(),
            ),
          );
        },
      );

      test(
        'You cannot use copyWith to create character with two fields with different names',
        () {
          // Given
          final field1 =
              Field.create(name: 'name', notes: [Note.create(value: "John")]);
          final fields = [field1];

          // When
          final character = Character.create(fields: fields);
          updateChracater() => character.copyWith(
                fields: [
                  Field.create(
                      name: 'name', notes: [Note.create(value: "John")]),
                  Field.create(
                      name: 'name', notes: [Note.create(value: "Doe")]),
                ],
              );

          // Then
          expect(
            updateChracater,
            throwsA(
              isA<Exception>(),
            ),
          );
        },
      );
    },
  );

  group(
    'Character moveNoteBetweenFields tests',
    () {
      test(
        'If moved note is not in any of character fields, throw an exception',
        () {
            // Given
            final field1 = Field.create(name: 'field1', notes: [Note.create(value: "Note1")]);
            final field2 = Field.create(name: 'field2', notes: []);
            final fields = [field1, field2];
            final character = Character.create(fields: fields);

            // When
            moveNote() => character.moveNoteBetweenFields(
              targetFieldName: 'field2',
              movedNoteId: 'nonexistent_note_id',
              );

            // Then
            expect(
            moveNote,
            throwsA(
              isA<NoteNotFoundException>(),
            ),
            );
        },
      );

      test(
        'If there is no targetField in character an exception is thrown',
        () {
          //Given
          final Note note = Note.create(value: "Note1");
          final Field field1 = Field.create(name: 'field1', notes: [note]);
          final Field field2 = Field.create(name: 'field2', notes: []);
          final List<Field> fields = [field1, field2];
          final Character character = Character.create(fields: fields);

          //When
          moveNote() => character.moveNoteBetweenFields(
            targetFieldName: 'nonexistent_field',
            movedNoteId: note.id,
          );


          //Then
          expect(
            moveNote,
            throwsA(
              isA<TargetFieldNotFoundException>(),
            ),
          );

        },
      );

      test(
        'If the source field and the target field are the same. Origninal Character is returned',
        () {
          //Given
          final note = Note.create(value: "Note1");
          final Field field1 = Field.create(name: 'field1', notes: [note]);
          final Field field2 = Field.create(name: 'field2', notes: []);
          final List<Field> fields = [field1, field2];
          final Character character = Character.create(fields: fields);

          //When
          final updatedCharacter = character.moveNoteBetweenFields(
            targetFieldName: 'field1',
            movedNoteId: note.id,
          );

          //Then
          expect(updatedCharacter, character);
        },
      );

      test(
        'If the source field and the target field are different. The note after moving is not any longer in the source field.',
        () {
          //Given
          final note = Note.create(value: "Note1");
          final Field field1 = Field.create(name: 'field1', notes: [note]);
          final Field field2 = Field.create(name: 'field2', notes: []);
          final List<Field> fields = [field1, field2];
          final Character character = Character.create(fields: fields);

          //When
          final updatedCharacter = character.moveNoteBetweenFields(
            targetFieldName: 'field2',
            movedNoteId: note.id,
          );

          //Then
          expect(updatedCharacter.fields[0].notes, isEmpty);
        },
      );

      test(
        'If the source field and the target field are different. The note after moving is in the target field.',
        () {
          //Given
          final note = Note.create(value: "Note1");
          final Field field1 = Field.create(name: 'field1', notes: [note]);
          final Field field2 = Field.create(name: 'field2', notes: []);
          final List<Field> fields = [field1, field2];
          final Character character = Character.create(fields: fields);

          //When
          final updatedCharacter = character.moveNoteBetweenFields(
            targetFieldName: 'field2',
            movedNoteId: note.id,
          );

          //Then
          expect(updatedCharacter.fields[1].notes, isNotEmpty);
        },
      );

      test(
        'After moving the note is not in any other field',
        () {
          //Given
          final note = Note.create(value: "Note1");
          final Field field1 = Field.create(name: 'field1', notes: [note]);
          final Field field2 = Field.create(name: 'field2', notes: []);
          final Field field3 = Field.create(name: 'field3', notes: []);
          final List<Field> fields = [field1, field2, field3];
          final Character character = Character.create(fields: fields);

          //When
          final updatedCharacter = character.moveNoteBetweenFields(
            targetFieldName: 'field2',
            movedNoteId: note.id,
          );

          //Then
          expect(updatedCharacter.fields[0].notes, isEmpty);
          expect(updatedCharacter.fields[2].notes, isEmpty);
        },
      );
    },
  );
}
