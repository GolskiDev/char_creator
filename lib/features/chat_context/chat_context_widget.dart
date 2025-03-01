import 'package:char_creator/features/chat_context/chat_context.dart';
import 'package:char_creator/features/documents/document_providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../documents/document.dart';
import '../fields/field_values/field_value.dart';
import 'chat_context_providers.dart';

class ChatContextWidget extends HookConsumerWidget {
  const ChatContextWidget({
    this.currentDocumentId,
    super.key,
  });
  final String? currentDocumentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatContext = ref.watch(chatContextProvider);
    final documentsAsync = ref.watch(documentsProvider);

    final currentDocument = documentsAsync.asData?.value.firstWhereOrNull(
      (document) => document.id == currentDocumentId,
    );

    final otherDocumentsAddedToContext = documentsAsync.asData?.value.where(
          (document) =>
              chatContext.referencedDocumentIds.contains(document.id) &&
              document.id != currentDocumentId,
        ) ??
        [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Current Context',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ListTile(
                title: const Text('Use Chat Context'),
                trailing: Switch(
                  value: ref.watch(isChatContextEnabledProvider),
                  onChanged: (bool value) {
                    ref.read(isChatContextEnabledProvider.notifier).state =
                        value;
                  },
                ),
              ),
              if (currentDocument != null)
                Card.filled(
                  margin: const EdgeInsets.all(0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CurrentDocumentContextWidget(
                      document: currentDocument,
                    ),
                  ),
                ),
              ...otherDocumentsAddedToContext.map(
                (document) {
                  return Card.outlined(
                    margin: const EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ContextDocumentWidget(
                        document: document,
                        contextValueKeys: chatContext.contextValueKeys
                            .where(
                              (contextValueKey) =>
                                  contextValueKey.documentId == document.id,
                            )
                            .toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ContextDocumentWidget extends HookConsumerWidget {
  const ContextDocumentWidget({
    required this.document,
    required this.contextValueKeys,
    super.key,
  });

  final Document document;
  final List<ChatContextValueKey> contextValueKeys;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final List<(ChatContextValueKey, String, String)> data = contextValueKeys
        .map(
          (contextValueKey) {
            final fieldName = contextValueKey.fieldName;
            final value = document.fields
                .firstWhereOrNull((field) => field.name == fieldName)
                ?.values
                .whereType<StringValue>()
                .firstWhereOrNull(
                  (value) =>
                      value.value.hashCode.toString() ==
                      contextValueKey.stringValueHash,
                );
            if (value == null) return null;
            return (contextValueKey, fieldName, value.value);
          },
        )
        .nonNulls
        .toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.displayedName,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          spacing: 4,
          runSpacing: 4,
          children: data.map(
            (fieldValue) {
              final contextValueKey = fieldValue.$1;
              final field = fieldValue.$2;
              final value = fieldValue.$3;

              return InputChip(
                label: Text('$field: $value'),
                onDeleted: () {
                  final chatContext = ref.read(chatContextProvider);
                  ref.read(chatContextProvider.notifier).state =
                      chatContext.removeKeyFromContext(
                    key: contextValueKey,
                  );
                },
              );
            },
          ).toList(),
        ),
      ],
    );
  }
}

class CurrentDocumentContextWidget extends HookConsumerWidget {
  const CurrentDocumentContextWidget({
    required this.document,
    super.key,
  });

  final Document document;

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final documents = ref.watch(documentsProvider).asData?.value;
    final chatContext = ref.watch(chatContextProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          document.displayedName,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        ...document.fields.map(
          (field) {
            final stringValues = field.values.whereType<StringValue>();
            final referenceValues =
                field.values.whereType<DocumentReferenceValue>();
            if (stringValues.isEmpty && referenceValues.isEmpty) {
              return null;
            }
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    field.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.start,
                    spacing: 4,
                    runSpacing: 4,
                    children: [
                      ...field.values.map(
                        (value) {
                          switch (value) {
                            case StringValue value:
                              final contextValueKey =
                                  ChatContextValueKey.fromDocument(
                                document: document,
                                field: field,
                                stringValue: value,
                              );
                              final isSelected = chatContext.contextValueKeys
                                  .contains(contextValueKey);
                              return ChoiceChip(
                                label: Text(value.value),
                                selected: isSelected,
                                onSelected: (isSelected) {
                                  if (isSelected) {
                                    ref
                                        .read(chatContextProvider.notifier)
                                        .state = chatContext.addKeyToContext(
                                      key: contextValueKey,
                                    );
                                    return;
                                  } else {
                                    ref
                                            .read(chatContextProvider.notifier)
                                            .state =
                                        chatContext.removeKeyFromContext(
                                      key: contextValueKey,
                                    );
                                  }
                                },
                              );
                            case DocumentReferenceValue value:
                              final isSelected =
                                  chatContext.contextValueKeys.any(
                                (contextValueKey) =>
                                    contextValueKey.documentId == value.refId,
                              );
                              final referencedDocument =
                                  documents?.firstWhereOrNull(
                                (document) => document.id == value.refId,
                              );
                              if (referencedDocument == null) return null;
                              return ChoiceChip(
                                label: Text(referencedDocument.displayedName),
                                selected: isSelected,
                                onSelected: (wasSelected) {
                                  if (wasSelected) {
                                    // add all context keys for this document
                                    final keysToAdd = referencedDocument.fields
                                        .map(
                                          (field) => field.values
                                              .whereType<StringValue>()
                                              .map(
                                                (stringValue) =>
                                                    ChatContextValueKey
                                                        .fromDocument(
                                                  document: referencedDocument,
                                                  field: field,
                                                  stringValue: stringValue,
                                                ),
                                              )
                                              .nonNulls,
                                        )
                                        .nonNulls
                                        .expand((element) => element);
                                    ref
                                            .read(chatContextProvider.notifier)
                                            .state =
                                        chatContext.addMultipleKeysToContext(
                                      keys: keysToAdd,
                                    );
                                  } else {
                                    // remove all context keys for this document
                                    ref
                                            .read(chatContextProvider.notifier)
                                            .state =
                                        chatContext
                                            .removeAllKeysOfDocumentFromContext(
                                      documentId: value.refId,
                                    );
                                  }
                                },
                              );
                            default:
                              return null;
                          }
                        },
                      ).nonNulls,
                    ],
                  ),
                ],
              ),
            );
          },
        ).nonNulls,
      ],
    );
  }
}
