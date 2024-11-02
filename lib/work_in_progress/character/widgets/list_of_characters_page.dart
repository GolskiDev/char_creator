import 'package:char_creator/work_in_progress/character/character.dart';
import 'package:char_creator/work_in_progress/character/character_use_cases.dart';
import 'package:char_creator/work_in_progress/character/widgets/create_character_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character_providers.dart';

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
    return ListView(
      children: [
        ...characters.map(
          (character) {
            final characterName = character.fields
                    .firstWhere((field) => field.name == 'Name')
                    .notes
                    .firstOrNull
                    ?.value ??
                'New Character';
            return ListTile(
              title: Text(characterName),
              onTap: () {
                context.go('/characters/${character.id}');
              },
            );
          },
        ),
        _addCharacterWidget(context, ref),
      ],
    );
  }

  _addCharacterWidget(
    BuildContext context,
    WidgetRef ref,
  ) {
    return ListTile(
      title: const Text('Create new character'),
      trailing: const Icon(Icons.add),
      onTap: () {
        CharacterUseCases.createNewCharacter(ref);
      },
    );
  }
}
