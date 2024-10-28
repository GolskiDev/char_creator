import 'package:char_creator/work_in_progress/character/character_repository.dart';
import 'package:char_creator/work_in_progress/character/character_use_cases.dart';
import 'package:char_creator/work_in_progress/character/field.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../character.dart';

class CreateCharacterWidget extends HookConsumerWidget {
  const CreateCharacterWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create a new character'),
            FilledButton(
              onPressed: () {
                CharacterUseCases.createNewCharacter(ref);
              },
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
  }
}
