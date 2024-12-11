import 'package:char_creator/features/dynamic_types/dynamic_types_repository.dart';
import 'package:char_creator/features/fields/field_values/field_value.dart';
import 'package:collection/collection.dart';

import '../documents/document.dart';
import '../dynamic_types/models/document_type_model.dart';

class BasicViewModel {
  final String id;
  final String? imagePath;
  final String? title;
  final String? description;

  BasicViewModel({
    required this.id,
    this.title,
    this.description,
    this.imagePath,
  });
}

extension DocumentBasicViewModel on Document {
  BasicViewModel basicViewModel(List<DocumentTypeModel> documentTypeModels) {
    List<String> descriptionFieldNames = ['description'];
    final String? description = fields
        .firstWhereOrNull((field) => descriptionFieldNames.contains(field.name))
        ?.values
        .whereType<StringValue>()
        .firstOrNull
        ?.value;

    List<String> imagePathFieldNames = ['images'];
    final String? imagePath = fields
        .firstWhereOrNull((field) => imagePathFieldNames.contains(field.name))
        ?.values
        .whereType<ImageValue>()
        .firstOrNull
        ?.url;

    final String? typeImagePath = documentTypeModels
        .firstWhereOrNull(
            (documentTypeModel) => documentTypeModel.documentType == type)
        ?.iconPath;

    return BasicViewModel(
      id: id,
      title: displayedName,
      description: description,
      imagePath: imagePath ??
          typeImagePath ??
          DynamicTypesRepository.plainDocumentIconPath,
    );
  }
}
