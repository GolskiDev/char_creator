import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_5e_model_v1.dart';
import 'character_local_data_source.dart';
import 'character_remote_firestore_data_source.dart';

final characterRepositoryProvider = FutureProvider(
  (ref) async {
    final localDataSource =
        await ref.watch(characterLocalDataSourceProvider.future);
    return CharacterRepository(
      localDataSource: localDataSource,
      remoteDataSource: ref.watch(characterRemoteFirestoreDataSourceProvider),
    );
  },
);

final charactersStreamProvider =
    StreamProvider.autoDispose<List<Character5eModelV1>>(
  (ref) async* {
    final characterRepository =
        await ref.watch(characterRepositoryProvider.future);
    yield* characterRepository.stream;
  },
);

class CharacterRepository {
  final CharacterLocalDataSource localDataSource;
  final CharacterRemoteFirestoreDataSource remoteDataSource;

  CharacterRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  }) {
    remoteDataSource.stream.listen((remoteCharacters) async {
      await localDataSource.replaceAll(remoteCharacters);
    });
  }

  Stream<List<Character5eModelV1>> get stream => remoteDataSource.stream;

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await remoteDataSource.saveCharacter(character);
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    try {
      return await remoteDataSource.getAllCharacters();
    } catch (_) {
      return await localDataSource.getAllCharacters();
    }
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    await remoteDataSource.updateCharacter(updatedCharacter);
  }

  Future<void> deleteCharacter(String characterId) async {
    await remoteDataSource.deleteCharacter(characterId);
  }
}
