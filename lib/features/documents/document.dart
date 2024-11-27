import 'package:char_creator/common/interfaces/identifiable.dart';

import '../fields/field.dart';

class Document implements Identifiable {
  @override
  final String id;
  final String? type;
  final List<Field> fields;

  Document._({
    required this.id,
    required this.fields,
    this.type,
  }) {
    if (!validateFieldsHaveDifferentNames()) {
      throw ArgumentError('Fields must have different names');
    }
  }

  bool validateFieldsHaveDifferentNames() {
    final fieldNames = fields.map((field) => field.name).toSet();
    return fieldNames.length == fields.length;
  }

  factory Document.create({
    List<Field> fields = const [],
  }) {
    return Document._(
      id: IdGenerator.generateId(Document),
      fields: fields,
    );
  }

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document._(
      id: json['id'],
      type: json['type'],
      fields: (json['fields'] as List)
          .map((field) => Field.fromJson(field))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fields': fields.map((field) => field.toJson()).toList(),
    };
  }

  Document copyWith({
    List<Field>? fields,
    String? type,
  }) {
    return Document._(
      id: id,
      type: type ?? this.type,
      fields: fields ?? this.fields,
    );
  }
}
