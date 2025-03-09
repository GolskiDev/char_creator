import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character_5e_model.dart';

final characterRepositoryProvider = Provider(
  (ref) => CharacterRepository(),
);

final charactersStreamProvider = StreamProvider.autoDispose<List<Character5eModel>>(
  (ref) => ref.watch(characterRepositoryProvider).stream,
);

class CharacterRepository {
  static const String _storageKey = 'characters';

  Stream<List<Character5eModel>> get stream => _controller.stream;

  final StreamController<List<Character5eModel>> _controller;

  CharacterRepository()
      : _controller = StreamController<List<Character5eModel>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeCharacter(Character5eModel character) {
    final Map<String, dynamic> characterMap = character.toJson();
    return json.encode(characterMap);
  }

  Character5eModel _decodeCharacter(String encodedCharacter) {
    final Map<String, dynamic> characterMap = json.decode(encodedCharacter);
    return Character5eModel.fromJson(characterMap);
  }

  Future<void> saveCharacter(Character5eModel character) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedCharacter = _encodeCharacter(character);
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    characters.add(encodedCharacter);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<List<Character5eModel>> getAllCharacters() async {
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

  Future<void> updateCharacter(Character5eModel updatedCharacter) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> characters = prefs.getStringList(_storageKey) ?? [];
    final int index = characters.indexWhere((c) =>
        Character5eModel.fromJson(json.decode(c)).id == updatedCharacter.id);
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
        (c) => Character5eModel.fromJson(json.decode(c)).id == characterId);
    await prefs.setStringList(_storageKey, characters);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    final List<Character5eModel> characters = await getAllCharacters();
    _controller.add(characters);
  }
}
