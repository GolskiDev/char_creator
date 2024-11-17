import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'character.dart';
import 'character_providers.dart';
import 'character_repository.dart';
import 'field.dart';

final characterUseCasesProvider = Provider(
  (ref) {
    final characterRepository = ref.watch(characterRepositoryProvider);
    return CharacterUseCases(
      characterRepository: characterRepository,
    );
  },
);

class CharacterUseCases {
  final CharacterRepository _characterRepository;

  CharacterUseCases({
    required CharacterRepository characterRepository,
  }) : _characterRepository = characterRepository;

  Future<void> createNewCharacter() {
    return _characterRepository.saveCharacter(
      Character.create(
        fields: [
          Field.create(
            name: 'Name',
            notes: [],
          ),
          Field.create(
            name: 'Class',
            notes: [],
          ),
          Field.create(
            name: 'Race',
            notes: [],
          ),
          Field.create(
            name: 'Skills',
            notes: [],
          ),
          Field.create(
            name: 'Background',
            notes: [],
          ),
          Field.create(
            name: 'Equipment',
            notes: [],
          ),
          Field.create(
            name: 'Spells',
            notes: [],
          ),
        ],
      ),
    );
  }
}
