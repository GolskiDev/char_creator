import 'package:char_creator/features/standard_layout/basic_view_model.dart';
import 'package:char_creator/features/standard_layout/widgets/card_widget.dart';
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
    final crossAxisCount =
        documentsAsync != null && documentsAsync.length > 2 ? 2 : 1;
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
      body: documentsAsync == null
          ? const Center(child: CircularProgressIndicator())
          : GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: 9 / 16,
              mainAxisSpacing: 8,
              padding: const EdgeInsets.all(8),
              crossAxisSpacing: 8,
              children: [
                ...documentsAsync.map(
                  (document) => GestureDetector(
                    onTap: () {
                      context.go(
                        '/documents/${document.id}',
                      );
                    },
                    child: CardWidget(
                      basicViewModel: document.basicViewModel,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
