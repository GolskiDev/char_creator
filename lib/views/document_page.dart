import 'dart:math';

import 'package:char_creator/features/basic_chat_support/my_chat_widget.dart';
import 'package:char_creator/features/documents/document_providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/fields/field.dart';
import '../features/fields/field_value.dart';

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
                          final loremIpsumWords = [
                            'Lorem',
                            'ipsum',
                            'dolor',
                            'sit',
                            'amet',
                            'consectetur',
                            'adipiscing',
                            'elit',
                            'sed',
                            'do',
                            'eiusmod',
                            'tempor',
                            'incididunt',
                            'ut',
                            'labore',
                            'et',
                            'dolore',
                            'magna',
                            'aliqua'
                          ];
                          final randomWord = (loremIpsumWords..shuffle()).first;

                          final updatedFields = document.fields.map((f) {
                            if (f == field) {
                              return f.copyWith(
                                values: [
                                  ...f.values,
                                  StringValue(
                                    value: randomWord,
                                  ),
                                ],
                              );
                            }
                            return f;
                          }).toList();

                          ref.read(documentRepositoryProvider).updateDocument(
                                document.copyWith(fields: updatedFields),
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
                            default:
                              return null;
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
}
