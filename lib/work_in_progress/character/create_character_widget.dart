import 'package:char_creator/work_in_progress/character/character_repository.dart';
import 'package:char_creator/work_in_progress/character/character_widget.dart';
import 'package:char_creator/work_in_progress/character/field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'character.dart';
import 'character_providers.dart';

class CreateCharacterWidget extends HookConsumerWidget {
  const CreateCharacterWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = ref.watch(charactersProvider).asData?.value ?? [];

    if (characters.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create a new character'),
            FilledButton(
              onPressed: () {
                ref.read(characterRepositoryProvider).saveCharacter(
                      Character.create(
                        fields: [
                          const Field(
                            name: 'Name',
                            notes: [],
                          ),
                          const Field(
                            name: 'Class',
                            notes: [],
                          ),
                        ],
                      ),
                    );
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
    } else {
      return CharacterWidget(
        character: characters.first,
      );
    }
  }
}
