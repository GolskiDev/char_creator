import 'package:char_creator/work_in_progress/character/character.dart';
import 'package:char_creator/work_in_progress/character/widgets/create_character_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character_providers.dart';
import 'character_page.dart';

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
      case AsyncData(:final value):
        if (value.isEmpty) {
          body = const CreateCharacterWidget();
        } else {
          body = _listOfCharacters(value);
        }
      default:
        body = const Center(
          child: CircularProgressIndicator(),
        );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      body: body,
    );
  }

  Widget _listOfCharacters(List<Character> characters) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        final characterName = character.fields.firstWhere((field) => field.name == 'Name').notes.firstOrNull?.value ?? 'New Character';
        return ListTile(
          title: Text(characterName),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CharacterPage(
                  characterId: character.id,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
