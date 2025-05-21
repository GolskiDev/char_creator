import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/character_5e_model_v1.dart';
import 'character_local_data_source.dart';
import 'character_remote_firestore_data_source.dart';

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(
    localDataSource: ref.watch(characterLocalDataSourceProvider),
    remoteDataSource: ref.watch(characterRemoteFirestoreDataSourceProvider),
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
  }) {
    // Listen to remote changes and update local if changed
    remoteDataSource.stream.listen((remoteCharacters) async {
      final localCharacters = await localDataSource.getAllCharacters();
      if (!_areCharacterListsEqual(localCharacters, remoteCharacters)) {
        for (final character in remoteCharacters) {
          // Fire and forget local save
          localDataSource.saveCharacter(character);
        }
      }
    });
  }

  bool _areCharacterListsEqual(
      List<Character5eModelV1> a, List<Character5eModelV1> b) {
    if (a.length != b.length) return false;
    final aSorted = List.of(a)..sort((x, y) => x.id.compareTo(y.id));
    final bSorted = List.of(b)..sort((x, y) => x.id.compareTo(y.id));
    for (int i = 0; i < aSorted.length; i++) {
      if (aSorted[i].toMap().toString() != bSorted[i].toMap().toString()) {
        return false;
      }
    }
    return true;
  }

  Stream<List<Character5eModelV1>> get stream => localDataSource.stream;

  Future<void> saveCharacter(Character5eModelV1 character) async {
    // Fire and forget local save
    localDataSource.saveCharacter(character);
    try {
      await remoteDataSource.saveCharacter(character);
    } catch (_) {}
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    try {
      return await localDataSource.getAllCharacters();
    } catch (_) {
      try {
        return await remoteDataSource.getAllCharacters();
      } catch (_) {
        return [];
      }
    }
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    localDataSource.updateCharacter(updatedCharacter);
    try {
      await remoteDataSource.updateCharacter(updatedCharacter);
    } catch (_) {}
  }

  Future<void> deleteCharacter(String characterId) async {
    localDataSource.deleteCharacter(characterId);
    try {
      await remoteDataSource.deleteCharacter(characterId);
    } catch (_) {}
  }
}
