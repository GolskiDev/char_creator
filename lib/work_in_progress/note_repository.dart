import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'note.dart';

final characterTraitRepositoryProvider = Provider<CharacterTraitRepository>(
  (ref) => CharacterTraitRepository(),
);

class CharacterTraitRepository {
  static const String _storageKey = 'characterTraits';

  Stream<List<Note>> get stream => _controller.stream;

  final StreamController<List<Note>> _controller;

  CharacterTraitRepository()
      : _controller = StreamController<List<Note>>.broadcast() {
    _controller.onListen = _refreshStream;
  }

  String _encodeTrait(Note trait) {
    final Map<String, dynamic> traitMap = trait.toJson();
    return json.encode(traitMap);
  }

  Note _decodeTrait(String encodedTrait) {
    final Map<String, dynamic> traitMap = json.decode(encodedTrait);
    return Note.fromJson(traitMap);
  }

  Future<void> saveTrait(Note trait) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedTrait = _encodeTrait(trait);
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    traits.add(encodedTrait);
    await prefs.setStringList(_storageKey, traits);

    await _refreshStream();
  }

  Future<List<Note>> getAllTraits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encodedTraits = prefs.getStringList(_storageKey);
    if (encodedTraits == null) {
      return [];
    }
    final traits = encodedTraits
        .map((encodedTrait) => _decodeTrait(encodedTrait))
        .toList();
    return traits;
  }

  Future<void> updateTrait(Note updatedTrait) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    final int index = traits
        .indexWhere((t) => Note.fromJson(json.decode(t)).id == updatedTrait.id);
    if (index != -1) {
      traits[index] = _encodeTrait(updatedTrait);
      await prefs.setStringList(_storageKey, traits);
    }

    await _refreshStream();
  }

  Future<void> deleteTrait(String traitId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    traits.removeWhere((t) => Note.fromJson(json.decode(t)).id == traitId);
    await prefs.setStringList(_storageKey, traits);

    await _refreshStream();
  }

  Future<void> _refreshStream() async {
    // update the stream
    final List<Note> traits = await getAllTraits();
    print('refreshing stream with ${traits.length} traits');
    _controller.add(traits);
  }
}
