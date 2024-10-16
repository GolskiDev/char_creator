import '../notes/note.dart';

class Field {
  final String name;
  final List<Note> notes;

  const Field({
    required this.name,
    required this.notes,
  });

  Field copyWith({
    String? name,
    List<Note>? notes,
  }) {
    return Field(
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
    return Field(
      name: json['name'],
      notes:
          (json['notes'] as List).map((note) => Note.fromJson(note)).toList(),
    );
  }
}
