import '../../common/interfaces/identifiable.dart';

class Note extends Identifiable {
  final String value;

  const Note._({
    required super.id,
    required this.value,
  });

  factory Note.create({
    required String value,
  }) {
    return Note._(
      id: IdGenerator.generateId(Note),
      value: value,
    );
  }

  static validateValue(String? value) {
    if (value == null) {
      throw ArgumentError(
        'Value cannot be null',
      );
    }
    if (value.isEmpty) {
      throw ArgumentError.value(
        value,
        null,
        'Value cannot be empty',
      );
    }
  }

  Note copyWith({String? value}) {
    return Note._(
      id: id,
      value: value ?? this.value,
    );
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note._(
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
