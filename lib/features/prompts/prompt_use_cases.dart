import 'package:collection/collection.dart';

import '../documents/document.dart';
import 'prompt_model.dart';
import 'prompts.dart';

class PromptUseCases {
  static List<PromptModel> getAllPrompts() {
    final promptModels = Prompts.prompts
        .map(
          (prompt) {
            try {
              return PromptModel(
                documentType: prompt['documentType'],
                requiredFieldNames:
                    List<String>.from(prompt['requiredFieldNames']),
                prompt: prompt['prompt'],
                outputFieldName: prompt['outputFieldName'],
              );
            } catch (e) {
              return null;
            }
          },
        )
        .whereNotNull()
        .toList();

    return promptModels;
  }

  static List<PromptModel> getAllAvailablePromptsForDocument(
    Document document,
  ) {
    final allPrompts = getAllPrompts();
    final promptsForDocumentType = allPrompts
        .where(
          (prompt) => prompt.documentType == document.type,
        )
        .toList();

    // Filter out prompts that require fields that are not present in the document
    // Document must have all required fields for the prompt to be available
    // Field names must be the same as the prompt's required field names
    // Each field must have atlest one value
    final availablePrompts = promptsForDocumentType
        .where(
          (prompt) => prompt.requiredFieldNames.every(
            (fieldName) {
              final field = document.fields.firstWhereOrNull(
                (field) => field.name == fieldName,
              );

              return field != null && field.values.isNotEmpty;
            },
          ),
        )
        .toList();

    return availablePrompts;
  }
}
