import 'package:spells_and_tools/common/interfaces/identifiable.dart';
import 'package:collection/collection.dart';

class Character5eNotes {
  /// Id: note
  final Map<String, Character5eNote> notes;

  const Character5eNotes({
    required this.notes,
  });

  factory Character5eNotes.empty() {
    return const Character5eNotes(
      notes: {},
    );
  }

  factory Character5eNotes.fromMap(Map<String, dynamic> json) {
    final notes = <String, Character5eNote>{};

    for (final entry in json.entries) {
      notes[entry.key] = Character5eNote.fromMap(entry.value);
    }

    return Character5eNotes(
      notes: notes,
    );
  }

  Map<String, dynamic> toMap() {
    final notes = <String, dynamic>{};

    for (final entry in this.notes.entries) {
      notes[entry.key] = entry.value.toMap();
    }

    return notes;
  }

  Character5eNotes copyWith({
    Map<String, Character5eNote>? notes,
  }) {
    return Character5eNotes(
      notes: notes ?? this.notes,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Character5eNotes &&
        other.notes.length == notes.length &&
        MapEquality().equals(other.notes, notes);
  }

  @override
  int get hashCode => MapEquality().hash(notes);
}

class Character5eNote implements Identifiable {
  @override
  final String id;
  final String content;

  const Character5eNote({
    required this.id,
    this.content = '',
  });

  factory Character5eNote.empty() {
    return Character5eNote(
      id: IdGenerator.generateId(Character5eNote),
      content: '',
    );
  }

  factory Character5eNote.fromMap(Map<String, dynamic> json) {
    return Character5eNote(
      id: json['id'] as String,
      content: json['content'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  Character5eNote copyWith({
    String? content,
  }) {
    return Character5eNote(
      id: id,
      content: content ?? this.content,
    );
  }
}
