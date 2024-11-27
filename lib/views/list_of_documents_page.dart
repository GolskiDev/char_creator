import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/documents/document.dart';
import '../features/documents/document_providers.dart';

class ListOfDocumentsPage extends ConsumerWidget {
  const ListOfDocumentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final documentsAsync = ref.watch(documentsProvider).asData?.value;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(documentRepositoryProvider).saveDocument(
                Document.create(
                  fields: [],
                ),
              );
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: <Widget>[
          if (documentsAsync != null)
            ...documentsAsync.map(
              (document) => Card(
                child: InkWell(
                  onTap: () {
                    context.go(
                      '/documents/${document.id}',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(document.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
