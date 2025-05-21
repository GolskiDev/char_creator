import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_5e_model_v1.dart';
import 'character_local_data_source.dart';
import 'character_remote_firestore_data_source.dart';

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(
    localDataSource: CharacterLocalDataSource(),
    remoteDataSource: CharacterRemoteFirestoreDataSource(),
  ),
);

final charactersStreamProvider =
    StreamProvider.autoDispose<List<Character5eModelV1>>(
  (ref) => ref.watch(characterRepositoryProvider).stream,
);

class CharacterRepository {
  final CharacterLocalDataSource localDataSource;
  final CharacterRemoteFirestoreDataSource remoteDataSource;

  CharacterRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  Stream<List<Character5eModelV1>> get stream => localDataSource.stream;

  Future<void> saveCharacter(Character5eModelV1 character) async {
    try {
      await remoteDataSource.saveCharacter(character);
    } catch (_) {
      await localDataSource.saveCharacter(character);
    }
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    try {
      final remoteCharacters = await remoteDataSource.getAllCharacters();
      return remoteCharacters;
    } catch (_) {
      return await localDataSource.getAllCharacters();
    }
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    try {
      await remoteDataSource.updateCharacter(updatedCharacter);
    } catch (_) {
      await localDataSource.updateCharacter(updatedCharacter);
    }
  }

  Future<void> deleteCharacter(String characterId) async {
    try {
      await remoteDataSource.deleteCharacter(characterId);
    } catch (_) {
      await localDataSource.deleteCharacter(characterId);
    }
  }
}
