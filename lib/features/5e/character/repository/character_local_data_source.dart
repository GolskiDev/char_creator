import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/shared_preferences.dart';
import '../models/character_5e_model_v1.dart';

final characterLocalDataSourceProvider =
    FutureProvider<UserCharactersLocalDataSource>(
  (ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return UserCharactersLocalDataSource(
      sharedPreferences,
    );
  },
);

class UserCharactersLocalDataSource {
  static const String _storageKey = 'characters';
  final SharedPreferences prefs;

  UserCharactersLocalDataSource(this.prefs);

  String _encodeCharacter(Character5eModelV1 character) {
    final Map<String, dynamic> characterMap = character.toMap();
    return json.encode(characterMap);
  }

  Character5eModelV1 _decodeCharacter(String encodedCharacter) {
    final Map<String, dynamic> characterMap = json.decode(encodedCharacter);
    return Character5eModelV1.fromMap(characterMap);
  }

  Future<void> replaceAll(List<Character5eModelV1> characters) async {
    final List<String> encodedCharacters =
        characters.map(_encodeCharacter).toList();
    await prefs.setStringList(_storageKey, encodedCharacters);
  }

  Future<List<Character5eModelV1>> getAllUserCharacters() async {
    final List<String>? encodedCharacters = prefs.getStringList(_storageKey);
    final sharedPrefsCharacters = encodedCharacters ?? [];
    final characters = sharedPrefsCharacters
        .map((encodedCharacter) => _decodeCharacter(encodedCharacter))
        .toList();
    return [
      ...characters,
    ];
  }
}
