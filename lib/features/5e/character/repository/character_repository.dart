import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_5e_model_v1.dart';
import 'character_local_data_source.dart';

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(
    localDataSource: CharacterLocalDataSource(),
  ),
);

final charactersStreamProvider =
    StreamProvider.autoDispose<List<Character5eModelV1>>(
  (ref) => ref.watch(characterRepositoryProvider).stream,
);

class CharacterRepository {
  final CharacterLocalDataSource localDataSource;

  CharacterRepository({required this.localDataSource});

  Stream<List<Character5eModelV1>> get stream => localDataSource.stream;

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await localDataSource.saveCharacter(character);
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    return await localDataSource.getAllCharacters();
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    await localDataSource.updateCharacter(updatedCharacter);
  }

  Future<void> deleteCharacter(String characterId) async {
    await localDataSource.deleteCharacter(characterId);
  }
}
