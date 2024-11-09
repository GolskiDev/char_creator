import '../notes/note.dart';

class Field {
  final String name;
  final List<Note> notes;

  Field._({
    required this.name,
    required this.notes,
  }) {
    validateNotes();
  }

  bool validateNotes() {
    final noteIds = notes.map((note) => note.id).toSet();
    if (noteIds.length != notes.length) {
      throw Exception('Field cannot store 2 notes with the same id');
    }
    return true;
  }

  factory Field.create({
    String? name,
    List<Note>? notes,
  }) {
    return Field._(
      name: name ?? 'New Field',
      notes: notes ?? [],
    );
  }

  Field copyWith({
    String? name,
    List<Note>? notes,
  }) {
    return Field._(
      name: name ?? this.name,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'notes': notes.map((note) => note.toJson()).toList(),
    };
  }

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field._(
      name: json['name'],
      notes:
          (json['notes'] as List).map((note) => Note.fromJson(note)).toList(),
    );
  }
}
