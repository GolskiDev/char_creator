import 'package:char_creator/features/dynamic_types/models/document_type_model.dart';
import 'package:collection/collection.dart';

import 'data/document_types.dart';
import 'data/field_types.dart';
import 'models/field_type_model.dart';

class DynamicTypesRepository {
  static List<DocumentTypeModel> getAvailableDocumentTypes() {
    final allFieldTypeModels = FieldTypes.fieldTypesMaps
        .map((e) {
          try {
            return Map<String, dynamic>.from(e);
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .map((entry) {
          try {
            return FieldTypeModel.fromMap(entry);
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .toList();

    final allDocumentTypeModels = DocumentTypes.documentTypesMaps
        .map((e) {
          try {
            return Map<String, dynamic>.from(e);
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .map((entry) {
          try {
            return DocumentTypeModel.fromMapAndFieldModels(
              entry,
              allFieldTypeModels,
            );
          } catch (e) {
            return null;
          }
        })
        .whereNotNull()
        .toList();

    return allDocumentTypeModels;
  }

  static List<FieldTypeModel> getCommonFieldTypes() {
    final commonFieldTypeNames = ['name', 'image', 'description'];

    return FieldTypes.fieldTypesMaps
        .map((entry) => FieldTypeModel.fromMap(entry))
        .where(
          (fieldTypeModel) =>
              commonFieldTypeNames.contains(fieldTypeModel.name),
        )
        .toList();
  }
}
