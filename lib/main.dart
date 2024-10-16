import 'package:char_creator/work_in_progress/notes/note.dart';
import 'package:char_creator/work_in_progress/views/edit_note_page.dart';
import 'package:char_creator/work_in_progress/views/list_of_notes_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'work_in_progress/identifiable.dart';
import 'work_in_progress/notes/note_repository.dart';
import 'work_in_progress/tags/tag_providers.dart';
import 'work_in_progress/views/chat_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Row(
          children: [
            Expanded(
              flex: 2,
              child: ListOfTraitsPage(),
            ),
            Expanded(
              flex: 5,
              child: ChatPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class ListOfTraitsPage extends ConsumerWidget {
  const ListOfTraitsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterTraitRepository =
        ref.watch(characterTraitRepositoryProvider);
    return Scaffold(
      body: const Center(
        child: ListOfTraitsWrapper(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push<String>(
            MaterialPageRoute<String>(
              builder: (context) => TraitFormPage(
                onSavePressed: (context, ref, formState) async {
                  if (formState.value.isNotEmpty) {
                    final newNote = Note.create(value: formState.value);
                    await characterTraitRepository.saveTrait(newNote);

                    if (formState.tags.isNotEmpty) {
                      final tagRepository =
                          await ref.read(tagRepositoryProvider.future);

                      await tagRepository.addTagsToObject(
                        newNote,
                        formState.tags,
                      );
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ListOfTraitsWrapper extends ConsumerWidget {
  const ListOfTraitsWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterTraitRepository =
        ref.watch(characterTraitRepositoryProvider);
    return StreamBuilder(
      stream: characterTraitRepository.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final data = snapshot.data as List<Identifiable>;
        return ListOfNotesWidget(
          traits: data,
        );
      },
    );
  }
}
