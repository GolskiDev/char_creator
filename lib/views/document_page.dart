import 'dart:io';

import 'package:char_creator/features/documents/document.dart';
import 'package:char_creator/features/documents/document_providers.dart';
import 'package:char_creator/features/images/image_providers.dart';
import 'package:char_creator/features/images/image_use_cases.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/basic_chat_support/chat.dart';
import '../features/dynamic_types/dynamic_types_providers.dart';
import '../features/fields/field.dart';
import '../features/fields/field_values/field_value.dart';
import '../features/prompts/prompt_model.dart';
import '../features/prompts/prompt_use_cases.dart';

class DocumentPage extends ConsumerWidget {
  const DocumentPage({
    required this.documentId,
    super.key,
  });
  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref
        .watch(documentsProvider)
        .asData
        ?.value
        .firstWhere((d) => d.id == documentId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document'),
        actions: [
          if (document != null) ...[
            IconButton(
              icon: const Icon(Icons.lightbulb_outline),
              onPressed: () {
                _showPrompts(
                  context: context,
                  ref: ref,
                  document: document,
                );
              },
            ),
          ],
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () {
              context.go('/documents/$documentId/chat');
            },
          ),
        ],
      ),
      floatingActionButton: document != null
          ? FloatingActionButton(
              onPressed: () => _addNewField(
                context,
                ref,
                document,
              ),
              child: const Icon(Icons.add),
            )
          : null,
      body: ListView(
        children: <Widget>[
          if (document != null)
            ...document.fields.map(
              (field) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(field.name),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          _onAddPressed(
                            context: context,
                            ref: ref,
                            document: document,
                            field: field,
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: [
                      ...field.values.map(
                        (value) {
                          switch (value) {
                            case StringValue string:
                              return Chip(
                                label: Text(string.value),
                              );
                            case DocumentReference ref:
                              return ActionChip(
                                onPressed: () => context.go(
                                  '/documents/${ref.refId}',
                                ),
                                label: Text(ref.refId),
                              );
                            case ImageValue image:
                              return Image.file(
                                File(image.url),
                              );
                          }
                        },
                      ).whereNotNull()
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _addNewField(
    BuildContext context,
    WidgetRef ref,
    Document document,
  ) async {
    final TextEditingController controller = TextEditingController();
    final documentTypes = ref.read(documentTypesProvider);
    final documentType = documentTypes.firstWhereOrNull(
      (type) => type.documentType == document.type,
    );
    final availableFieldModels = documentType?.fields
        .where((field) => !document.fields.any((f) => f.name == field.name))
        .toList();

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (availableFieldModels != null &&
            availableFieldModels.isNotEmpty) ...[
          Text(
            'Select type',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.start,
          ),
          ...availableFieldModels.map(
            (field) => ListTile(
              title: Text(field.label),
              onTap: () {
                Navigator.of(context).pop(field.name);
              },
              trailing: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Text(
            'Or create custom field',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter field name'),
          ),
        ] else ...[
          TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter field name'),
          ),
        ],
      ],
    );

    final String? fieldName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add new field'),
          content: SingleChildScrollView(
            child: content,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (fieldName != null && fieldName.isNotEmpty) {
      final updatedDocument = document.copyWith(
        fields: [
          ...document.fields,
          Field(
            name: fieldName,
            values: [],
          ),
        ],
      );
      ref.read(documentRepositoryProvider).updateDocument(updatedDocument);
    }
  }

  Widget _buildFieldValueWidget(BuildContext context, FieldValue value) {
    switch (value) {
      case StringValue string:
        return Chip(
          label: Text(string.value),
        );
      case DocumentReference ref:
        return ActionChip(
          onPressed: () => context.go(
            '/documents/${ref.refId}',
          ),
          label: Text(ref.refId),
        );
      case ImageValue image:
        return Image.file(
          File(image.url),
        );
      default:
        throw ArgumentError('Invalid field value type');
    }
  }

  void _onAddPressed({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
    required Field field,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Value or Reference'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Add Value'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showAddValueDialog(context, ref, document, field);
                },
              ),
              ListTile(
                title: const Text('Create Reference'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showCreateReferenceDialog(context, ref, document, field);
                },
              ),
              ListTile(
                title: const Text('Pick Image'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showPickImageDialog(context, ref, document, field);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPickImageDialog(
    BuildContext context,
    WidgetRef ref,
    Document document,
    Field field,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: const Text('Feature to pick image from repository'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final imageRepository =
                    await ref.read(imageRepositoryProvider.future);
                final imageModel =
                    await ImageUseCases.pickFromLocalDeviceAndSave(
                        imageRepository);
                final ImageValue imageValue =
                    ImageValue(url: imageModel.filePath);
                final updatedField = field.copyWith(
                  values: [
                    ...field.values,
                    imageValue,
                  ],
                );
                final updatedDocument = document.copyWith(
                  fields: document.fields.map((f) {
                    return f.name == field.name ? updatedField : f;
                  }).toList(),
                );
                await ref.read(documentRepositoryProvider).updateDocument(
                      updatedDocument,
                    );
                if (!context.mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Pick Image'),
            ),
          ],
        );
      },
    );
  }

  void _showAddValueDialog(
    BuildContext context,
    WidgetRef ref,
    Document document,
    Field field,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: const Text('Add Value'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedField = field.copyWith(
                  values: [
                    ...field.values,
                    StringValue(value: controller.text),
                  ],
                );
                final updatedDocument = document.copyWith(
                  fields: document.fields.map((f) {
                    return f.name == field.name ? updatedField : f;
                  }).toList(),
                );
                ref.read(documentRepositoryProvider).updateDocument(
                      updatedDocument,
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showCreateReferenceDialog(
    BuildContext context,
    WidgetRef ref,
    Document document,
    Field field,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final documents = ref
            .watch(documentsProvider)
            .asData
            ?.value
            .where((d) => d.id != document.id)
            .toList();

        return AlertDialog(
          title: const Text('Create Reference'),
          content: documents != null
              ? SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      final doc = documents[index];
                      return ListTile(
                        title: Text(doc.id),
                        onTap: () {
                          final updatedField = field.copyWith(
                            values: [
                              ...field.values,
                              DocumentReference(refId: doc.id),
                            ],
                          );
                          final updatedDocument = document.copyWith(
                            fields: document.fields.map((f) {
                              return f.name == field.name ? updatedField : f;
                            }).toList(),
                          );
                          ref.read(documentRepositoryProvider).updateDocument(
                                updatedDocument,
                              );
                          Navigator.of(context).pop();
                        },
                      );
                    },
                  ),
                )
              : const CircularProgressIndicator(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showPrompts({
    required BuildContext context,
    required WidgetRef ref,
    required Document document,
  }) {
    final avialablePrompts =
        PromptUseCases.getAllAvailablePromptsForDocument(document);

    if (avialablePrompts.isEmpty) {
      return;
    }

    onPromptPressed(
      PromptModel prompt,
    ) async {
      final chat = await ref.read(chatProvider.future);
      final generatedPrompt =
          PromptUseCases.generatePromptFromPromptModelAndDocument(
        prompt,
        document,
      );
      chat.sendUserMessage(generatedPrompt);
      if (!context.mounted) return;
      context.push('/chat/${document.id}');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ideas'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: avialablePrompts.map((prompt) {
                return ListTile(
                  title: Text(prompt.prompt),
                  onTap: () {
                    onPromptPressed(prompt);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
