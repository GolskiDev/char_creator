import 'dart:async';

import 'package:char_creator/features/character/character.dart';
import 'package:char_creator/features/for_portfolio/character_repository_rest/retry_inteceptor.dart';
import 'package:dio/dio.dart';

import '../../character/character_repository.dart';
import 'remote_repository_errors.dart' as remote_errors;
import 'rest_errors.dart' as rest_errors;

class CharacterRepositoryDio implements CharacterRepository {
  final String baseUrl;
  final Dio dio;
  final StreamController<List<Character>> _controller;

  CharacterRepositoryDio({
    required this.baseUrl,
  })  : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
          ),
        ),
        _controller = StreamController<List<Character>>.broadcast() {
    _controller.onListen = _refreshStream;

    dio.interceptors.add(
      RetryInterceptor(
        maxRetries: 3,
        retryInterval: const Duration(seconds: 10),
        dio: Dio(
          BaseOptions(
            baseUrl: baseUrl,
          ),
        ),
      ),
    );
  }

  @override
  Future<void> saveCharacter(Character character) async {
    try {
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
    } on DioException catch (e) {
      throw _mapToMyExceptions(e);
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    try {
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
    } on DioException catch (e) {
      throw _mapToMyExceptions(e);
    }
  }

  @override
  Stream<List<Character>> get stream => _controller.stream;

  @override
  Future<void> updateCharacter(Character updatedCharacter) async {
    try {
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
    } on DioException catch (e) {
      throw _mapToMyExceptions(e);
    }
  }

  @override
  Future<void> deleteCharacter(String characterId) async {
    try {
      final response = await dio.delete(
        '/characters/$characterId',
      );

      if (response.statusCode == 204) {
        _refreshStream();
        return;
      } else {
        throw Exception('Failed to delete character');
      }
    } on DioException catch (e) {
      throw _mapToMyExceptions(e);
    }
  }

  _refreshStream() async {
    try {
      final characters = await getAllCharacters();
      _controller.add(characters);
      return;
    } on DioException catch (e) {
      _controller.addError(_mapToMyExceptions(e));
    }
  }

  Exception _mapToMyExceptions(DioException e) {
    return switch (e) {
      DioException(
        type: DioExceptionType.connectionTimeout,
      ) =>
        remote_errors.ConnectionError(e.message),
      DioException(
        type: DioExceptionType.sendTimeout,
      ) =>
        remote_errors.RequestTimeoutError(e.message),
      DioException(
        type: DioExceptionType.receiveTimeout,
      ) =>
        remote_errors.RequestTimeoutError(e.message),
      DioException(
        type: DioExceptionType.badCertificate,
      ) =>
        remote_errors.BadCertificateError(e.message),
      DioException(
        type: DioExceptionType.badResponse,
      ) =>
        _mapToRestError(e),
      DioException(
        type: DioExceptionType.cancel,
      ) =>
        remote_errors.RequestCancelledError(e.message),
      DioException(
        type: DioExceptionType.connectionError,
      ) =>
        remote_errors.ConnectionError(e.message),
      DioException(
        type: DioExceptionType.unknown,
      ) =>
        remote_errors.UnknownError(e.message),
    };
  }

  rest_errors.RestError _mapToRestError(DioException e) {
    return switch (e.response?.statusCode) {
      400 =>
        rest_errors.BadRequestError(e.response?.statusMessage ?? 'Bad request'),
      404 =>
        rest_errors.NotFoundError(e.response?.statusMessage ?? 'Not found'),
      408 => rest_errors.RequestTimeoutError(
          e.response?.statusMessage ?? 'Request timeout'),
      500 => rest_errors.InternalServerError(
          e.response?.statusMessage ?? 'Internal server error'),
      502 => rest_errors.InternalServerError(
          e.response?.statusMessage ?? 'Bad gateway'),
      504 => rest_errors.InternalServerError(
          e.response?.statusMessage ?? 'Gateway timeout'),
      _ => rest_errors.UnexpectedError(e.message),
    };
  }
}
