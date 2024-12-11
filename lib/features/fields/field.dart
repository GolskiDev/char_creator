import 'package:collection/collection.dart';

import '../dynamic_types/models/field_type_model.dart';
import 'field_values/field_value.dart';

class Field {
  final String name;
  final List<FieldValue> values;

  Field({
    required this.name,
    required this.values,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    switch (json) {
      case {
          'name': final String name,
          'values': final List<dynamic> values,
        }:
        final fieldValues = List<Map<String, dynamic>>.from(values)
            .map((value) => FieldValue.fromJson(value))
            .toList();
        return Field(
          name: name,
          values: fieldValues,
        );
      default:
        throw ArgumentError('Invalid field JSON');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'values': values.map((value) => value.toJson()).toList(),
    };
  }

  Field copyWith({
    String? name,
    List<FieldValue>? values,
  }) {
    return Field(
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }
}

extension FieldLabel on Field {
  String? getLabel(List<FieldTypeModel> fieldTypes) {
    final fieldType = fieldTypes.firstWhereOrNull(
      (fieldType) => fieldType.name == name,
    );
    return fieldType?.label;
  }
}
