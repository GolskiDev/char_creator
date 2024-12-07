import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../documents/document_providers.dart';
import 'chat_response_model.dart';

class MyMessageWidget extends HookConsumerWidget {
  const MyMessageWidget({
    required this.text,
    this.listOfValues,
    this.documentId,
    super.key,
  });

  final String text;
  final List<Map<String, dynamic>>? listOfValues;

  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );

    final listOfValuesWidget = listOfValues != null
        ? ListOfValuesWidget(
            listOfValues: listOfValues!,
            documentId: documentId,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        textWidget,
        if (listOfValuesWidget != null) listOfValuesWidget,
      ],
    );
  }
}

class ListOfValuesWidget extends HookConsumerWidget {
  const ListOfValuesWidget({
    required this.listOfValues,
    this.documentId,
    super.key,
  });
  final List<Map<String, dynamic>> listOfValues;
  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedValues = useState<List<String>>([]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: listOfValues.map(
            (value) {
              final fieldName = value['fieldName'] as String;
              final fieldValue = value['value'] as String;
              final isSelected = selectedValues.value.contains(fieldValue);

              return ChoiceChip(
                label: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      fieldName,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(fieldValue),
                  ],
                ),
                selected: isSelected,
                onSelected: (value) {
                  if (value) {
                    selectedValues.value = [
                      ...selectedValues.value,
                      fieldValue
                    ];
                  } else {
                    selectedValues.value = selectedValues.value
                        .where((element) => element != fieldValue)
                        .toList();
                  }
                },
              );
            },
          ).toList(),
        ),
        FilledButton(
          onPressed: () async {
            if (documentId == null) {
              return;
            }
            final fieldsToAdd = listOfValues
                .where(
                  (value) => selectedValues.value.contains(value['value']),
                )
                .toList();
            final documents = await ref.read(documentsProvider.future);
            final document = documents.firstWhereOrNull(
              (document) => document.id == documentId,
            );
            if (document == null) {
              return;
            }
            final updatedDocument = ChatResponseModel.addToDocument(
              fieldsToAdd,
              document,
            );
            await ref
                .read(documentRepositoryProvider)
                .updateDocument(updatedDocument);
            selectedValues.value = [];
          },
          child: const Text('Add to Doument'),
        ),
      ],
    );
  }
}
