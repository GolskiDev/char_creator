import 'package:collection/collection.dart';

import '../../common/interfaces/identifiable.dart';
import '../notes/note.dart';
import 'field.dart';

class Character implements Identifiable {
  final String _id;
  final List<Field> _fields;

  @override
  String get id => _id;
  List<Field> get fields => List.unmodifiable(_fields);

  Character._({
    required String id,
    required List<Field> fields,
  })  : _id = id,
        _fields = fields {
    fieldValidator(fields);
  }

  bool fieldValidator(Iterable<Field> fields) {
    final fieldNames = fields.map((field) => field.name);
    final uniqueFieldNames = fieldNames.toSet();
    if (fieldNames.length != uniqueFieldNames.length) {
      throw DuplicateFieldNameException();
    }
    return true;
  }

  factory Character.create({
    required List<Field> fields,
  }) {
    final id = IdGenerator.generateId(Character);
    return Character._(id: id, fields: fields);
  }

  Character copyWith({
    List<Field>? fields,
  }) {
    return Character._(
      id: _id,
      fields: fields ?? _fields,
    );
  }

  Character moveNoteBetweenFields({
    required String targetFieldName,
    required String movedNoteId,
  }) {
    final fromField = fields.firstWhereOrNull(
      (field) => field.notes.any((note) => note.id == movedNoteId),
    );

    if (fromField == null) {
      throw NoteNotFoundException(movedNoteId);
    }

    final movedNote =
        fromField.notes.firstWhere((note) => note.id == movedNoteId);

    final targetField = fields.firstWhereOrNull(
      (field) => field.name == targetFieldName,
    );

    if (targetField == null) {
      throw TargetFieldNotFoundException(targetFieldName);
    }

    final fromFieldIndex = fields.indexOf(fromField);
    final targetFieldIndex = fields.indexOf(targetField);

    if (fromFieldIndex == targetFieldIndex) {
      return this;
    }

    final updatedFromField = fromField.copyWith(
      notes: fromField.notes.where((n) => n.id != movedNoteId).toList(),
    );

    final updatedToField = targetField.copyWith(
      notes: [...targetField.notes, movedNote],
    );

    final updatedFields = fields.map((f) {
      if (f == fromField) {
        return updatedFromField;
      } else if (f == targetField) {
        return updatedToField;
      } else {
        return f;
      }
    }).toList();

    return copyWith(fields: updatedFields);
  }

  Character addOrUpdateNoteInField({
    required String fieldName,
    required Note note,
  }) {
    final field = fields.firstWhereOrNull((f) => f.name == fieldName);
    if (field == null) {
      throw TargetFieldNotFoundException(fieldName);
    }

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

    return copyWith(
      fields: fields.map((f) => f == field ? updatedField : f).toList(),
    );
  }

  Character deleteNoteInField({
    required Field field,
    required Note note,
  }) {
    final isNoteInTheField = field.notes.any((n) => n.id == note.id);

    if (!isNoteInTheField) {
      throw NoteNotFoundException(note.id);
    }

    final updatedNotes = field.notes.where((n) => n != note).toList();

    final updatedField = field.copyWith(notes: updatedNotes);

    final updatedCharacter = copyWith(
      fields: fields.map((f) => f == field ? updatedField : f).toList(),
    );

    return updatedCharacter;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'fields': _fields.map((field) => field.toJson()).toList(),
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character._(
      id: json['id'],
      fields: (json['fields'] as List)
          .map((field) => Field.fromJson(field))
          .toList(),
    );
  }
}

class CharacterException implements Exception {
  final String message;
  CharacterException(this.message);

  @override
  String toString() => 'CharacterException: $message';
}

class NoteNotFoundException extends CharacterException {
  NoteNotFoundException(String noteId)
      : super('Note with id $noteId not found in any field');
}

class TargetFieldNotFoundException extends CharacterException {
  TargetFieldNotFoundException(String fieldName)
      : super('Target field with name $fieldName does not exist in character');
}

class DuplicateFieldNameException extends CharacterException {
  DuplicateFieldNameException() : super('Fields must have unique names');
}
