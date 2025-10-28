import 'package:spells_and_tools/features/5e/character/models/character_5e_model_v1.dart';
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
    List<Character5eModelV1> characters,
  ) {
    return GridView.extent(
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      padding: const EdgeInsets.all(8),
      maxCrossAxisExtent: 200,
      childAspectRatio: 3 / 4,
      children: characters
          .map(
            (character) => Card.outlined(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () {
                  context.go('/characters/${character.id}');
                },
                child: Center(
                  heightFactor: 1.5,
                  child: Text(
                    character.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
