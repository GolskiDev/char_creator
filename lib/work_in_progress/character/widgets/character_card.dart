import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character.dart';

class CharacterCard extends HookConsumerWidget {
  const CharacterCard({
    required this.character,
    super.key,
  });
  final Character character;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characterName = character.fields
            .firstWhere((field) => field.name == 'Name')
            .notes
            .firstOrNull
            ?.value ??
        'New Character';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          characterName,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
