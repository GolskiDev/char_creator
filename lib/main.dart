import 'package:char_creator/work_in_progress/character_trait.dart';
import 'package:char_creator/work_in_progress/views/list_of_characters_traits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'work_in_progress/character_trait_repository.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MaterialApp(
      home: TheApp(),
    );
  }
}

class TheApp extends StatelessWidget {
  const TheApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListOfTraitsWrapper(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          CharacterTraitRepository().saveTrait(
            SingleValueCharacterTrait(
              id: 'race',
              value: 'Human',
            ),
          );
        },
      ),
    );
  }
}

class ListOfTraitsWrapper extends StatelessWidget {
  const ListOfTraitsWrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: CharacterTraitRepository().getAllTraits(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done) {
          return const CircularProgressIndicator();
        }
        if (data == null) {
          return const Text('No traits found');
        }
        return ListOfCharacterTraitsWidget(
          traits: data,
        );
      },
    );
  }
}
