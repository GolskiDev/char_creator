import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dynamic_types_repository.dart';
import 'models/document_type_model.dart';

final documentTypesProvider = Provider<List<DocumentTypeModel>>(
  (ref) {
    return DynamicTypesRepository.getAvailableDocumentTypes();
  },
);
