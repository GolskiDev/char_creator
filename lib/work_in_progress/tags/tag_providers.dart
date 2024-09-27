import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/shared_preferences.dart';
import '../identifiable.dart';
import 'tag.dart';
import 'tag_repository_shared_prefs.dart';

final tagsOfObjectProvider = FutureProvider.family<Set<Tag>, Identifiable>(
  (ref, object) async {
    final tagRepository = await ref.watch(tagRepositoryProvider.future);
    final tags = tagRepository.getTagsForObject(object);
    return tags;
  },
);

final tagsProvider = StreamProvider<List<Tag>>(
  (ref) async* {
    final tagRepository = await ref.watch(tagRepositoryProvider.future);

    yield* tagRepository.stream;
  },
);

final tagRepositoryProvider = FutureProvider<TagRepositorySharedPrefs>(
  (ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);

    return TagRepositorySharedPrefs(
      sharedPreferences,
    );
  },
);
