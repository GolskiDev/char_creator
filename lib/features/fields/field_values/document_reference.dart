part of 'field_value.dart';

class DocumentReference implements FieldValue {
  static const String typeId = 'reference';

  final String refId;

  DocumentReference({required this.refId});

  static fromJson(Map<String, dynamic> json) {
    return DocumentReference(
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
