import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/shared_preferences.dart';
import '../models/character_5e_class_model_v1.dart';
import 'character_classes_remote_data_source.dart';

final characterClassesRepositoryProvider = FutureProvider(
  (ref) async {
    final sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    return CharacterClassesRepository(
      remoteDataSource: ref.watch(characterClassesRemoteDataSourceProvider),
      sharedPreferences: sharedPreferences,
    );
  },
);

final characterClassesStreamProvider =
    StreamProvider<List<ICharacter5eClassModelV1>>(
  (ref) async* {
    final repository =
        await ref.watch(characterClassesRepositoryProvider.future);
    yield* repository.stream;
  },
);

class CharacterClassesRepository {
  static const String _storageKey = 'character_classes';

  final CharacterClassesRemoteDataSource remoteDataSource;
  final SharedPreferencesWithCache sharedPreferences;

  Stream<List<ICharacter5eClassModelV1>> get stream => _controller.stream;

  final StreamController<List<ICharacter5eClassModelV1>> _controller;
  late final StreamSubscription<List<ICharacter5eClassModelV1>>
      _remoteStreamSubscription;

  CharacterClassesRepository({
    required this.remoteDataSource,
    required this.sharedPreferences,
  }) : _controller =
            StreamController<List<ICharacter5eClassModelV1>>.broadcast() {
    _controller.onListen = _refreshStream;

    // Listen to the remote data source stream
    _remoteStreamSubscription =
        remoteDataSource.stream.listen((remoteClasses) async {
      final localClasses = await getAllCharacterClasses();

      // Combine local and remote classes, ensuring no duplicates
      final combinedClasses = {
        for (var cls in remoteClasses) cls.id: cls,
        for (var cls in localClasses) cls.id: cls,
      }.values.toList();

      _controller.add(combinedClasses);
    });
  }

  String _encodeCharacterClass(ICharacter5eClassModelV1 characterClass) {
    final Map<String, dynamic> classMap = characterClass.toMap();
    return json.encode(classMap);
  }

  ICharacter5eClassModelV1 _decodeCharacterClass(String encodedClass) {
    final Map<String, dynamic> classMap = json.decode(encodedClass);
    return Character5eCustomClassModelV1.fromMap(classMap);
  }

  Future<void> saveCharacterClass(
      ICharacter5eClassModelV1 characterClass) async {
    final String encodedClass = _encodeCharacterClass(characterClass);
    List<String> classes = sharedPreferences.getStringList(_storageKey) ?? [];
    classes.add(encodedClass);
    await sharedPreferences.setStringList(_storageKey, classes);

    await _refreshStream();
  }

  Future<List<ICharacter5eClassModelV1>> getAllCharacterClasses() async {
    final List<String>? encodedClasses =
        sharedPreferences.getStringList(_storageKey);
    final sharedPrefsClasses = encodedClasses ?? [];

    final classes = sharedPrefsClasses
        .map((encodedClass) => _decodeCharacterClass(encodedClass))
        .toList();

    return [
      ...classes,
    ];
  }

  Future<void> updateCharacterClass(
    ICharacter5eClassModelV1 updatedClass,
  ) async {
    List<String> classes = sharedPreferences.getStringList(_storageKey) ?? [];
    final int index = classes.indexWhere((c) =>
        Character5eCustomClassModelV1.fromMap(json.decode(c)).id ==
        updatedClass.id);
    if (index != -1) {
      classes[index] = _encodeCharacterClass(updatedClass);
      await sharedPreferences.setStringList(_storageKey, classes);
    }

    await _refreshStream();
  }

  Future<void> deleteCharacterClass(String classId) async {
    List<String> classes = sharedPreferences.getStringList(_storageKey) ?? [];
    classes.removeWhere((c) =>
        Character5eCustomClassModelV1.fromMap(json.decode(c)).id == classId);
    await sharedPreferences.setStringList(_storageKey, classes);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    final List<ICharacter5eClassModelV1> localClasses =
        await getAllCharacterClasses();
    final List<ICharacter5eClassModelV1> remoteClasses =
        await remoteDataSource.stream.first;

    // Combine local and remote classes, ensuring no duplicates
    final combinedClasses = {
      for (var cls in remoteClasses) cls.id: cls,
      for (var cls in localClasses) cls.id: cls,
    }.values.toList();

    _controller.add(combinedClasses);
  }

  void dispose() {
    _remoteStreamSubscription.cancel();
    _controller.close();
  }
}
