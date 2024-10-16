import '../identifiable.dart';
import 'field.dart';

class Character implements Identifiable {
  final String _id;
  final List<Field> _fields;

  @override
  String get id => _id;
  List<Field> get fields => List.unmodifiable(_fields);

  const Character._({
    required String id,
    required List<Field> fields,
  })  : _id = id,
        _fields = fields;

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
