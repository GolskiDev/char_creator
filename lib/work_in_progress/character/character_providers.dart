import 'package:char_creator/work_in_progress/character/character_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'character.dart';

final charactersProvider = StreamProvider<List<Character>>((ref) async* {
  final characterRepository = ref.watch(characterRepositoryProvider);
  yield* characterRepository.stream;
});
