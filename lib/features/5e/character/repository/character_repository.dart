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
    yield* characterRepository.allUserCharactersStream;
  },
);

class CharacterRepository {
  final UserCharactersLocalDataSource localDataSource;
  final UserCharactersRemoteFirestoreDataSource remoteDataSource;

  CharacterRepository({
    required this.localDataSource,
    required this.remoteDataSource,
  }) {
    remoteDataSource.allUserCharactersStream.listen(
      (remoteCharacters) async {
        await localDataSource.replaceAll(remoteCharacters);
      },
    );
  }

  Stream<List<Character5eModelV1>> get allUserCharactersStream =>
      remoteDataSource.allUserCharactersStream;

  Future<List<Character5eModelV1>> getAllUserCharacters() async {
    try {
      return await remoteDataSource.getAllUserCharacters();
    } catch (_) {
      return await localDataSource.getAllUserCharacters();
    }
  }

  Future<void> saveCharacter(Character5eModelV1 character) async {
    await remoteDataSource.saveCharacter(character);
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    await remoteDataSource.updateCharacter(updatedCharacter);
  }

  Future<void> deleteCharacter(String characterId) async {
    await remoteDataSource.deleteCharacter(characterId);
  }
}
