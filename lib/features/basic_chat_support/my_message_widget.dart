import 'dart:io';

import 'package:char_creator/features/fields/field.dart';
import 'package:char_creator/features/images/image_providers.dart';
import 'package:char_creator/utils/image_automatic.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../documents/document_providers.dart';
import '../fields/field_values/field_value.dart';
import 'chat_response_model.dart';

class MyMessageWidget extends HookConsumerWidget {
  const MyMessageWidget({
    required this.text,
    this.listOfValues,
    this.documentId,
    this.imageId,
    super.key,
  });

  final String text;
  final List<Map<String, dynamic>>? listOfValues;
  final String? imageId;
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

    final imageWidget = imageId != null
        ? ImageWidget(
            imageId: imageId!,
            documentId: documentId,
          )
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        textWidget,
        if (listOfValuesWidget != null) listOfValuesWidget,
        if (imageWidget != null) imageWidget,
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
              final documentHasThisValue = ref
                  .watch(documentsProvider)
                  .asData
                  ?.value
                  .firstWhereOrNull(
                    (document) => document.id == documentId,
                  )
                  ?.fields
                  .any(
                    (field) =>
                        field.name == fieldName &&
                        field.values.any(
                          (fieldVal) =>
                              fieldVal is StringValue &&
                              fieldVal.value == fieldValue,
                        ),
                  );
              final isSelected = selectedValues.value.contains(fieldValue) ||
                  documentHasThisValue == true;
              final isDisabled = documentHasThisValue == true;

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
                onSelected: isDisabled
                    ? null
                    : (value) {
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
        if (selectedValues.value.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FilledButton(
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
          ),
      ],
    );
  }
}

class ImageWidget extends HookConsumerWidget {
  const ImageWidget({
    required this.imageId,
    this.documentId,
    super.key,
  });

  final String imageId;
  final String? documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Card.outlined(
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(),
                    extendBodyBehindAppBar: true,
                    body: Center(
                      child: InteractiveViewer(
                        child: Hero(
                          tag: imageId,
                          child: ImageAutomatic.build(
                            path: imageId,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Hero(
              tag: imageId,
              child: ImageAutomatic.build(
                path: imageId,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (documentId != null)
          UnconstrainedBox(
            child: FilledButton(
              onPressed: () async {
                final documents = await ref.read(documentsProvider.future);
                final document = documents.firstWhereOrNull(
                  (document) => document.id == documentId,
                );
                if (document == null) {
                  return;
                }
                final currentField = document.fields.firstWhereOrNull(
                      (field) => field.name == 'images',
                    ) ??
                    Field(
                      name: 'images',
                      values: [],
                    );
                final updatedDocument = document.updateOrInsertField(
                  currentField.copyWith(
                    values: [
                      ...currentField.values,
                      ImageValue(url: imageId),
                    ],
                  ),
                );
                await ref
                    .read(documentRepositoryProvider)
                    .updateDocument(updatedDocument);
              },
              child: const Text('Add to Document'),
            ),
          ),
      ],
    );
  }
}
