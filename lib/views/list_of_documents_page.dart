import 'package:char_creator/features/dynamic_types/dynamic_types_repository.dart';
import 'package:char_creator/features/standard_layout/basic_view_model.dart';
import 'package:char_creator/features/standard_layout/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../features/documents/document.dart';
import '../features/documents/document_providers.dart';
import '../features/dynamic_types/dynamic_types_providers.dart';

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
        onPressed: () async {
          final documentTypes = ref.read(
            documentTypesProvider,
          );
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select Document Type'),
                content: Consumer(
                  builder: (context, ref, child) => SingleChildScrollView(
                    child: ListBody(
                      children: documentTypes.map<Widget>(
                        (type) {
                          final icon = type.iconPath != null
                              ? SvgPicture.asset(
                                  type.iconPath!,
                                  width: 24,
                                  height: 24,
                                )
                              : null;
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: icon,
                              title: Text(
                                type.label,
                              ),
                              onTap: () async {
                                final documentRepository =
                                    ref.read(documentRepositoryProvider);
                                await documentRepository.saveDocument(
                                  Document.create(
                                    type: type.documentType,
                                  ),
                                );
                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        },
                      ).toList()
                        ..add(
                          Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              leading: SvgPicture.asset(
                                DynamicTypesRepository.plainDocumentIconPath,
                                width: 24,
                                height: 24,
                              ),
                              title: const Text('Plain Document'),
                              onTap: () async {
                                final documentRepository =
                                    ref.read(documentRepositoryProvider);
                                await documentRepository.saveDocument(
                                  Document.create(
                                    type: null,
                                  ),
                                );
                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
              );
            },
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
                      basicViewModel: document.basicViewModel(
                        ref.watch(documentTypesProvider),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
