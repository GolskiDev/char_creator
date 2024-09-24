import 'identifiable.dart';

class Note implements Identifiable {
  @override
  final String id;
  final String value;

  const Note({
    required this.id,
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
