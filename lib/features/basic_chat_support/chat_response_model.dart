import 'package:collection/collection.dart';

import '../documents/document.dart' as my_document;
import '../fields/field.dart';
import '../fields/field_values/field_value.dart';

class ChatResponseModel {
  final String response;
  final List<Map<String, dynamic>> values;

  ChatResponseModel({
    required this.response,
    required this.values,
  });

  factory ChatResponseModel.fromMap(Map<String, dynamic> map) {
    return ChatResponseModel(
      response: map['response'] as String,
      values: (map['values'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  static my_document.Document addToDocument(
    List<Map<String, dynamic>> values,
    my_document.Document document,
  ) {
    my_document.Document updatedDocument = document.copyWith();
    for (final value in values) {
      final fieldName = value['fieldName'] as String;
      final fieldValue = StringValue(value: value['value'] as String);

      final Field? field = updatedDocument.fields.firstWhereOrNull(
        (field) => field.name == fieldName,
      );

      if (field != null) {
        final updatedField = field.copyWith(
          values: [...field.values, fieldValue],
        );
        updatedDocument = updatedDocument.updateOrInsertField(updatedField);
      } else {
        updatedDocument = updatedDocument.updateOrInsertField(
          Field(
            name: fieldName,
            values: [fieldValue],
          ),
        );
      }
    }

    return updatedDocument;
  }
}