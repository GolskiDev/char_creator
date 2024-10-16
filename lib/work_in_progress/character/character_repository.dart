import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'character.dart';

final characterRepositoryProvider = Provider<CharacterRepository>(
  (ref) => CharacterRepository(),
);

class CharacterRepository {
  static const String _storageKey = 'characters';

  Stream<List<Character>> get stream => _controller.stream;

  final StreamController<List<Character>> _controller;

  CharacterRepository()
      : _controller = StreamController<List<Character>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeCharacter(Character character) {
    final Map<String, dynamic> characterMap = character.toJson();
    return json.encode(characterMap);
  }

  Character _decodeCharacter(String encodedCharacter) {
    final Map<String, dynamic> characterMap = json.decode(encodedCharacter);
    return Character.fromJson(characterMap);
  }

  Future<void> saveCharacter(Character character) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedCharacter = _encodeCharacter(character);
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    characters.add(encodedCharacter);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<List<Character>> getAllCharacters() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encodedCharacters = prefs.getStringList(_storageKey);
    if (encodedCharacters == null) {
      return [];
    }
    final characters = encodedCharacters
        .map((encodedCharacter) => _decodeCharacter(encodedCharacter))
        .toList();
    return characters;
  }

  Future<void> updateCharacter(Character updatedCharacter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    final int index = characters.indexWhere(
        (c) => Character.fromJson(json.decode(c)).id == updatedCharacter.id);
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
        (c) => Character.fromJson(json.decode(c)).id == characterId);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    final List<Character> characters = await getAllCharacters();
    print('refreshing stream with ${characters.length} characters');
    _controller.add(characters);
  }
}
