import 'dart:async';

import 'package:char_creator/features/character/character.dart';
import 'package:dio/dio.dart';

import '../../character/character_repository.dart';

class CharacterRepositoryDio implements CharacterRepository {
  final String baseUrl;
  final Dio dio;
  final StreamController<List<Character>> _controller;

  CharacterRepositoryDio({
    required this.baseUrl,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
          ),
        ), _controller = StreamController<List<Character>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  @override
  Future<void> saveCharacter(Character character) async {
    final response = await dio.post(
      '/characters',
      data: character.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 201) {
      _refreshStream();
      return;
    } else {
      throw Exception('Failed to save character');
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    final response = await dio.get('/characters');

    if (response.statusCode == 200) {
      final List<dynamic> charactersJson = response.data;
      final List<Character> characters = charactersJson
          .map((characterJson) => Character.fromJson(characterJson))
          .toList();
      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Stream<List<Character>> get stream => _controller.stream;

  @override
  Future<void> updateCharacter(Character updatedCharacter)async  {
    final response = await dio.put(
      '/characters/${updatedCharacter.id}',
      data: updatedCharacter.toJson(),
      options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ),
    );

    if (response.statusCode == 200) {
      _refreshStream();
      return;
    } else {
      throw Exception('Failed to update character');
    }
  }

  @override
  Future<void> deleteCharacter(String characterId) async {
    final response = await dio.delete(
      '/characters/$characterId',

    );

    if (response.statusCode == 204) {
      _refreshStream();
      return;
    } else {
      throw Exception('Failed to delete character');
    }
  }

  _refreshStream() async {
    final characters = await getAllCharacters();
    _controller.add(characters);
  }
}
