import 'package:char_creator/features/character/character_use_cases.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateCharacterWidget extends HookConsumerWidget {
  const CreateCharacterWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create a new character',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FilledButton(
            onPressed: () {
              final characterUseCases = ref.read(characterUseCasesProvider);
              characterUseCases.createNewCharacter();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
