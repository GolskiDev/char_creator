import 'package:char_creator/features/fields/field_values/field_value.dart';
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
                displayedPrompt: prompt['displayedPrompt'],
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
    final fieldValues = prompt.requiredFieldNames
        .map((fieldName) {
          final field = targetDocument.fields.firstWhereOrNull(
            (field) => field.name == fieldName,
          );
          return field?.values.whereType<StringValue>().first;
        })
        .expand(
          (element) => [element],
        )
        .toList();

    // example prompt
    // Generate 10 names for my character based on my {class} and {race}. Show me why you think this name is good, and from which culture or word it comes from. target Field name is "name'
    // replace {class} with value of class field

    final filledPrompt = prompt.prompt.replaceAllMapped(
      RegExp(r'{(\w+)}'),
      (match) {
        final fieldName = match.group(1);
        if (fieldName == null) {
          return '';
        }
        final fieldIndex = prompt.requiredFieldNames.indexOf(fieldName);
        return fieldValues[fieldIndex]?.value ?? '';
      },
    );

    if (prompt.outputFieldName == 'images') {
      return addImageTemplateToPrompt(filledPrompt);
    }

    return addValuesTemplateToPrompt(filledPrompt, prompt.outputFieldName);
  }

  static String addValuesTemplateToPrompt(
    String prompt,
    String? outputFieldName,
  ) {
    return '''$prompt
    Return all the details for user to see in "textMessage".
    Return all additional values in "values" array.
    This is request from application
    Return JSON only. Don't add extra text.
    Don't add extra ',' and escape special characters:
    {
      "textMessage": "String",
      "values": [
        {
          "value", "value",
          "fieldName": ${outputFieldName != null ? "$outputFieldName" : '"outputFieldName" //default: "other"'}
        }
      ],
    }
    Return JSON in format above 
    ''';
  }

  static String addImageTemplateToPrompt(String prompt) {
    return '''$prompt
    This is request for image generation from application.
    Return JSON only. Don't add extra text.
    Return JSON in this format. Don't add extra ',' and escape special characters:
    Return url to image you generated in imageUrl field.
    {
      "textMessage": "String",
      "imageUrl": "String",
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
