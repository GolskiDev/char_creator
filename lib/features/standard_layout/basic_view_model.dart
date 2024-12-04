import 'package:char_creator/features/fields/field_values/field_value.dart';
import 'package:collection/collection.dart';

import '../documents/document.dart';

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
  BasicViewModel get basicViewModel {
    List<String> titleFieldNames = ['name'];
    final String? title = fields
        .firstWhereOrNull((field) => titleFieldNames.contains(field.name))
        ?.values
        .whereType<StringValue>()
        .firstOrNull
        ?.value;

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

    return BasicViewModel(
      id: id,
      title: title ?? id.substring(0, runtimeType.toString().length + 5),
      description: description,
      imagePath: imagePath,
    );
  }
}
