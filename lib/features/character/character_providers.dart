import 'package:char_creator/features/character/character_repository.dart';
import 'package:char_creator/features/for_portfolio/character_repository_rest/character_repository_http.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'character.dart';

final charactersProvider = StreamProvider<List<Character>>((ref) async* {
  final characterRepository = ref.watch(characterRepositoryProvider);
  yield* characterRepository.stream;
});

final characterByIdProvider =
    FutureProvider.family<Character?, String>((ref, characterId) async {
  final characters = await ref.watch(charactersProvider.future);
  return characters
      .firstWhereOrNull((character) => character.id == characterId);
});

final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepositoryHttp(
    baseUrl: 'http://localhost:5000',
  ),
);