import 'package:char_creator/work_in_progress/character/character.dart';
import 'package:char_creator/work_in_progress/character/field.dart';
import 'package:char_creator/work_in_progress/notes/note.dart';
import 'package:test/test.dart';

void main() {
  test(
    'You cannot create character with two fields with the same name',
    () {
      // Given
      final field1 = Field(name: 'name', notes: [Note.create(value: "John")]);
      final field2 = Field(name: 'name', notes: [Note.create(value: "Doe")]);
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
      final field1 = Field(name: 'name', notes: [Note.create(value: "John")]);
      final fields = [field1];

      // When
      final character = Character.create(fields: fields);
      updateChracater() => character.copyWith(
            fields: [
              Field(name: 'name', notes: [Note.create(value: "John")]),
              Field(name: 'name', notes: [Note.create(value: "Doe")]),
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
}
