import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:char_creator/features/character/character.dart';
import 'package:char_creator/features/character/character_repository.dart';

class CharacterRepositoryHttp implements CharacterRepository {
  final String baseUrl;
  final StreamController<List<Character>> _controller;

  CharacterRepositoryHttp({
    required this.baseUrl,
  }) : _controller = StreamController<List<Character>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  @override
  Stream<List<Character>> get stream => _controller.stream;

  @override
  Future<void> saveCharacter(Character character) {
    final response = http.post(
      Uri.parse('$baseUrl/characters'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(character.toJson()),
    );
    return response.then(
      (value) {
        if (value.statusCode == 201) {
          return _refreshStream();
        } else {
          throw Exception('Failed to save character');
        }
      },
    );
  }

  @override
  Future<List<Character>> getAllCharacters() async  {
    final response = await http.get(Uri.parse('$baseUrl/characters'));
    if (response.statusCode == 200) {
      final List<dynamic> charactersJson = jsonDecode(response.body);
      final List<Character> characters = charactersJson
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Future<void> updateCharacter(Character updatedCharacter) {
    final response = http.put(
      Uri.parse('$baseUrl/characters/${updatedCharacter.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedCharacter.toJson()),
    );
    return response.then(
      (value) {
        if (value.statusCode == 200) {
          return _refreshStream();
        } else {
          throw Exception('Failed to update character');
        }
      },
    );
  }

  @override
  Future<void> deleteCharacter(String characterId) {
    final response = http.delete(
      Uri.parse('$baseUrl/characters/$characterId'),
    );
    return response.then(
      (value) {
        if (value.statusCode == 200) {
          return _refreshStream();
        } else {
          throw Exception('Failed to delete character');
        }
      },
    );
  }

  Future<void> _refreshStream() async {
    final List<Character> characters = await getAllCharacters();
    _controller.add(characters);
  }
}
