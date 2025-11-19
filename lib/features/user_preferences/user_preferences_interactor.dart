import 'package:riverpod/riverpod.dart';

import 'user_preference_interface.dart';
import 'user_preferences_repository.dart';

final userPrefrencesProvider = StreamProvider(
  (ref) async* {
    final repository =
        await ref.watch(userPreferencesRepositoryProvider.future);
    yield* repository.preferencesStream;
  },
);

final userPreferencesInteractorProvider = FutureProvider(
  (ref) async {
    final repository =
        await ref.watch(userPreferencesRepositoryProvider.future);
    return UserPreferencesInteractor(repository);
  },
);

class UserPreferencesInteractor {
  final UserPreferencesRepository _repository;

  UserPreferencesInteractor(this._repository);

  Stream<Map<String, dynamic>> get preferencesStream =>
      _repository.preferencesStream;

  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    await _repository.savePreferences(preferences);
  }

  Future<void> updatePreference(UserPreferenceInterface preference) async {
    final currentPreferences = await _repository.getPreferences();
    await _repository.savePreferences({
      ...currentPreferences,
      ...preference.toJson(),
    });
  }

  Future<void> clearPreferences() async {
    await _repository.clearPreferences();
  }
}
