import 'package:collection/collection.dart';
import 'package:langchain/langchain.dart';

import '../documents/document.dart' as my_document;
import '../fields/field.dart';
import '../fields/field_values/field_value.dart';
import '../prompts/prompt_model.dart';
import 'chat_bot.dart';

class ChatResult {
  final String response;
  final List<Map<String, dynamic>> values;

  ChatResult({
    required this.response,
    required this.values,
  });

  factory ChatResult.fromMap(Map<String, dynamic> map) {
    return ChatResult(
      response: map['response'] as String,
      values: (map['values'] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
    );
  }

  my_document.Document addToDocument(
    my_document.Document document,
  ) {
    my_document.Document updatedDocument = document.copyWith();
    for (final value in values) {
      final fieldName = value['fieldName'] as String;
      final fieldValue = StringValue(value: value['value'] as String);

      final Field? field = updatedDocument.fields.firstWhereOrNull(
        (field) => field.name == fieldName,
      );

      if (field != null) {
        final updatedField = field.copyWith(
          values: [...field.values, fieldValue],
        );
        updatedDocument = updatedDocument.updateOrInsertField(updatedField);
      } else {
        updatedDocument = updatedDocument.updateOrInsertField(
          Field(
            name: fieldName,
            values: [fieldValue],
          ),
        );
      }
    }

    return updatedDocument;
  }
}

class ChatUseCases {
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
    Return json format:
    {
      "response": "response for user without mentioning the prompt",
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

  static Future<String> askPrompt(
    PromptModel prompt,
    my_document.Document targetDocument,
    ChatBotWithMemory chat,
  ) {
    final filledPrompt = fillPromptWithValues(prompt, targetDocument);

    final promptTemplate = ChatPromptTemplate.fromPromptMessages(
      [
        const MessagesPlaceholder(variableName: 'history'),
        SystemChatMessagePromptTemplate.fromTemplate(
          '{input}',
        ),
      ],
    );

    final chain = Runnable.fromMap(
      {
        'input': Runnable.passthrough(),
        'history': Runnable.mapInput(
          (_) async {
            final m = await chat.memory.loadMemoryVariables();
            return m['history'];
          },
        ),
      },
    ).pipe(promptTemplate).pipe(chat.chat).pipe(
          const StringOutputParser(),
        );

    final response = chain.invoke({'input': filledPrompt});

    return response;
  }
}
