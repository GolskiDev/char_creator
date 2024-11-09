import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'character.dart';
import 'character_repository.dart';
import 'field.dart';

class CharacterUseCases {
  static Future<void> createNewCharacter(WidgetRef ref) {
    return ref.read(characterRepositoryProvider).saveCharacter(
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
  }
}
