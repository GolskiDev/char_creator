import 'dart:math';

import 'package:char_creator/features/documents/document.dart';
import 'package:char_creator/features/documents/document_providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/fields/field.dart';
import '../features/fields/field_values/field_value.dart';

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
      ),
      floatingActionButton: document != null
          ? FloatingActionButton(
              onPressed: () {
                final updatedDocument = document.copyWith(
                  fields: [
                    ...document.fields,
                    Field(
                      name: 'New Field ${Random().nextInt(100)}',
                      values: [],
                    ),
                  ],
                );
                ref.read(documentRepositoryProvider).updateDocument(
                      updatedDocument,
                    );
              },
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
              ],
            ),
          );
        });
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
}
