import 'package:char_creator/work_in_progress/note.dart';
import 'package:char_creator/work_in_progress/views/edit_trait_page.dart';
import 'package:char_creator/work_in_progress/views/list_of_characters_traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'work_in_progress/identifiable.dart';
import 'work_in_progress/note_repository.dart';
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
        onPressed: () async {
          final newValue = await Navigator.of(context).push<String>(
            MaterialPageRoute<String>(
              builder: (context) {
                return const EditStringPage();
              },
            ),
          );
          if (newValue != null) {
            characterTraitRepository.saveTrait(
              Note(
                id: "race",
                value: newValue,
              ),
            );
          }
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
        return ListOfCharacterTraitsWidget(
          traits: data,
        );
      },
    );
  }
}
