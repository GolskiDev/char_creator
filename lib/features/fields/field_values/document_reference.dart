part of 'field_value.dart';

class DocumentReferenceValue implements FieldValue {
  static const String typeId = 'reference';

  final String refId;

  DocumentReferenceValue({required this.refId});

  static fromJson(Map<String, dynamic> json) {
    return DocumentReferenceValue(
      refId: json['refId'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': typeId,
      'refId': refId,
    };
  }
}
