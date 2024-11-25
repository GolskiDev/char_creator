import 'package:char_creator/features/character/character.dart';
import 'package:char_creator/features/character/character_use_cases.dart';
import 'package:char_creator/features/character/widgets/create_character_widget.dart';
import 'package:char_creator/features/images/picking_images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../features/character/character_providers.dart';
import '../features/character/widgets/character_card.dart';

class ListOfCharactersPage extends HookConsumerWidget {
  const ListOfCharactersPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider);

    final Widget body;

    switch (characters) {
      case AsyncError():
        body = const Center(
          child: Text('An error occurred'),
        );
      case AsyncData(value: final characters):
        if (characters.isEmpty) {
          body = const CreateCharacterWidget();
        } else {
          body = _listOfCharacters(
            context,
            ref,
            characters,
          );
        }
      default:
        body = const Center(
          child: CircularProgressIndicator(),
        );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PickingImages.pickImage();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          'Characters',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: body,
    );
  }

  Widget _listOfCharacters(
    BuildContext context,
    WidgetRef ref,
    List<Character> characters,
  ) {
    Widget itemBuilder({
      required BuildContext context,
      required Widget child,
      required Function() onTap,
    }) {
      final borderRadius = BorderRadius.circular(8);
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: child,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: [
          ...characters.map(
            (character) => itemBuilder(
              context: context,
              child: CharacterCard(character: character),
              onTap: () => _onCharacterTap(context, ref, character),
            ),
          ),
          itemBuilder(
            context: context,
            child: _addCharacterWidget(context, ref),
            onTap: () {
              final characterUseCases = ref.read(characterUseCasesProvider);
              characterUseCases.createNewCharacter();
            },
          ),
        ],
      ),
    );
  }

  _addCharacterWidget(
    BuildContext context,
    WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Create new character',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const Icon(Icons.add),
        ],
      ),
    );
  }

  _onCharacterTap(
    BuildContext context,
    WidgetRef ref,
    Character character,
  ) {
    context.go('/characters/${character.id}');
  }
}
