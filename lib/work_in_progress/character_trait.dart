abstract class Identifiable {
  final String id;

  const Identifiable({required this.id});

  Map<String, dynamic> toJson();
}

class Note extends Identifiable {
  final String value;

  const Note({
    required super.id,
    required this.value,
  });

  Note copyWith({String? value}) {
    return Note(
      id: id,
      value: value ?? this.value,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
    };
  }
}
