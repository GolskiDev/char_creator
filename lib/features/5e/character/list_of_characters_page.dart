import 'package:char_creator/features/5e/character/models/character_5e_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'repository/character_repository.dart';

class ListOfCharactersPage extends HookConsumerWidget {
  const ListOfCharactersPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final charactersAsync = ref.watch(charactersStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Characters'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/characters/new');
        },
        child: const Icon(Icons.add),
      ),
      body: charactersAsync.when(
        data: (characters) {
          return _body(context, ref, characters);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) {
          return Center(
            child: Text('Error: $error'),
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    WidgetRef ref,
    List<Character5eModel> characters,
  ) {
    return ListView.builder(
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return ListTile(
          title: Text(character.name),
          onTap: () {},
        );
      },
    );
  }
}
