import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character_5e_model_v1.dart';

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(),
);

final charactersStreamProvider =
    StreamProvider.autoDispose<List<Character5eModelV1>>(
  (ref) => ref.watch(characterRepositoryProvider).stream,
);

class CharacterRepository {
  static const String _storageKey = 'characters';

  Stream<List<Character5eModelV1>> get stream => _controller.stream;

  final StreamController<List<Character5eModelV1>> _controller;

  CharacterRepository()
      : _controller = StreamController<List<Character5eModelV1>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeCharacter(Character5eModelV1 character) {
    final Map<String, dynamic> characterMap = character.toJson();
    return json.encode(characterMap);
  }

  Character5eModelV1 _decodeCharacter(String encodedCharacter) {
    final Map<String, dynamic> characterMap = json.decode(encodedCharacter);
    return Character5eModelV1.fromJson(characterMap);
  }

  Future<void> saveCharacter(Character5eModelV1 character) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedCharacter = _encodeCharacter(character);
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    characters.add(encodedCharacter);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<List<Character5eModelV1>> getAllCharacters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final List<String>? encodedCharacters = prefs.getStringList(_storageKey);
    final sharedPrefsCharacters = encodedCharacters ?? [];

    final characters = sharedPrefsCharacters
        .map((encodedCharacter) => _decodeCharacter(encodedCharacter))
        .toList();

    return [
      ...characters,
    ];
  }

  Future<void> updateCharacter(Character5eModelV1 updatedCharacter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    final int index = characters.indexWhere((c) =>
        Character5eModelV1.fromJson(json.decode(c)).id == updatedCharacter.id);
    if (index != -1) {
      characters[index] = _encodeCharacter(updatedCharacter);
      await prefs.setStringList(_storageKey, characters);
    }

    await _refreshStream();
  }

  Future<void> deleteCharacter(String characterId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    characters.removeWhere(
        (c) => Character5eModelV1.fromJson(json.decode(c)).id == characterId);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    final List<Character5eModelV1> characters = await getAllCharacters();
    _controller.add(characters);
  }
}
