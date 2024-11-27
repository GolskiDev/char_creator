part 'string_value.dart';
part 'document_reference.dart';

sealed class FieldValue {
  static FieldValue fromJson(Map<String, dynamic> json) {
    return switch (json['type']) {
      StringValue.typeId => StringValue.fromJson(json),
      DocumentReference.typeId => DocumentReference.fromJson(json),
      _ => throw ArgumentError('Invalid field value type'),
    };
  }

  Map<String, dynamic> toJson();
}
