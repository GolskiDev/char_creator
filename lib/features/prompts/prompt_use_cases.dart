import 'package:collection/collection.dart';

import '../documents/document.dart' as my_document;
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

  static String fillPromptWithValues(
    PromptModel prompt,
    my_document.Document targetDocument,
  ) {
    final fieldValues = prompt.requiredFieldNames.map((fieldName) {
      final field = targetDocument.fields.firstWhereOrNull(
        (field) => field.name == fieldName,
      );
      return field?.values.first;
    }).toList();

    final filledPrompt = prompt.prompt.replaceAllMapped(
      RegExp(r'{(\d+)}'),
      (match) {
        final index = int.parse(match.group(1) ?? '0');
        return fieldValues[index]?.toString() ?? '';
      },
    );

    return '''$filledPrompt
    Return JSON in this format. Don't add extra ',' and escape special characters:
    {
      "response": "String",
      "values": [
        {
          "value", "value",
          "fieldName": "${prompt.outputFieldName}
          }"
        }
      ]
    }
    ''';
  }

  static String generatePromptFromPromptModelAndDocument(
    PromptModel prompt,
    my_document.Document targetDocument,
  ) {
    final filledPrompt = fillPromptWithValues(prompt, targetDocument);

    return filledPrompt;
  }
}
