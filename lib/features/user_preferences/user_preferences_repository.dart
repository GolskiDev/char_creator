import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/shared_preferences.dart';

final userPreferencesRepositoryProvider =
    FutureProvider<UserPreferencesRepository>(
  (ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return UserPreferencesRepository(sharedPreferences);
  },
);

class UserPreferencesRepository {
  static const String _prefsKey = 'user_preferences';
  final SharedPreferencesWithCache _sharedPreferences;
  final StreamController<Map<String, dynamic>> _prefsStreamController =
      StreamController.broadcast();

  UserPreferencesRepository(this._sharedPreferences) {
    _prefsStreamController.onListen = () async {
      final prefs = await getPreferences();
      _prefsStreamController.add(prefs);
    };
  }

  Stream<Map<String, dynamic>> get preferencesStream =>
      _prefsStreamController.stream;

  Future<Map<String, dynamic>> getPreferences() async {
    final jsonString = _sharedPreferences.getString(_prefsKey);
    if (jsonString == null) {
      return {};
    }
    final decoded = await compute(jsonDecode, jsonString);
    final map = Map<String, dynamic>.from(decoded);
    _prefsStreamController.add(map);
    return map;
  }

  Future<void> savePreferences(Map<String, dynamic> preferences) async {
    final jsonString = await compute(jsonEncode, preferences);
    await _sharedPreferences.setString(_prefsKey, jsonString);
    _prefsStreamController.add(preferences);
  }

  Future<void> clearPreferences() async {
    await _sharedPreferences.remove(_prefsKey);
    _prefsStreamController.add({});
  }
}
