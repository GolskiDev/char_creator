import 'package:char_creator/features/dynamic_types/models/field_type_model.dart';

class DocumentTypeModel {
  final String documentType;
  final String label;
  final List<FieldTypeModel> fields;

  DocumentTypeModel({
    required this.documentType,
    required this.label,
    required this.fields,
  });

  factory DocumentTypeModel.fromMapAndFieldModels(
    Map<String, dynamic> map,
    List<FieldTypeModel> fieldModels,
  ) {
    return DocumentTypeModel(
      documentType: map['type'],
      label: map['label'],
      fields: fieldModels
          .where((fieldModel) => map['fields'].contains(fieldModel.name))
          .toList(),
    );
  }
}
