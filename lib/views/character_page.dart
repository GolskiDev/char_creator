import 'dart:io';

import 'package:char_creator/features/documents/document_providers.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/dynamic_types/dynamic_types_providers.dart';
import '../features/standard_layout/basic_view_model.dart';

class CharacterPage extends ConsumerWidget {
  const CharacterPage({
    super.key,
    required this.documentId,
  });
  final String documentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref
        .watch(documentsProvider)
        .asData
        ?.value
        .firstWhereOrNull((document) => document.id == documentId);
    if (document == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Character'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final basicViewModel = document.basicViewModel(
      ref.watch(documentTypesProvider),
    );
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (basicViewModel.imagePath != null)
                  Hero(
                    tag: basicViewModel.imagePath!,
                    child: Image.file(
                      File(basicViewModel.imagePath!),
                      fit: BoxFit.cover,
                    ),
                  ),
                if (basicViewModel.title != null)
                  Hero(
                    tag: basicViewModel.title ?? 'Character',
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          basicViewModel.title ?? 'Character',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                if (basicViewModel.description != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      basicViewModel.description!,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
