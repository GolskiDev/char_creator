import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'character_trait.dart';

class CharacterTraitRepository {
  static const String _storageKey = 'characterTraits';

  String _encodeTrait(CharacterTrait trait) {
    final Map<String, dynamic> traitMap = trait.toJson();
    return json.encode(traitMap);
  }

  CharacterTrait _decodeTrait(String encodedTrait) {
    final Map<String, dynamic> traitMap = json.decode(encodedTrait);
    return CharacterTrait.fromJson(traitMap);
  }

  Future<void> saveTrait(CharacterTrait trait) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String encodedTrait = _encodeTrait(trait);
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    traits.add(encodedTrait);
    await prefs.setStringList(_storageKey, traits);
  }

  Future<List<CharacterTrait>> getAllTraits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? encodedTraits = prefs.getStringList(_storageKey);
    if (encodedTraits == null) {
      return [];
    }
    return encodedTraits
        .map((encodedTrait) => _decodeTrait(encodedTrait))
        .toList();
  }

  Future<void> updateTrait(CharacterTrait updatedTrait) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    final int index = traits.indexWhere(
        (t) => CharacterTrait.fromJson(json.decode(t)).id == updatedTrait.id);
    if (index != -1) {
      traits[index] = _encodeTrait(updatedTrait);
      await prefs.setStringList(_storageKey, traits);
    }
  }

  Future<void> deleteTrait(String traitId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> traits = prefs.getStringList(_storageKey) ?? [];
    traits.removeWhere(
        (t) => CharacterTrait.fromJson(json.decode(t)).id == traitId);
    await prefs.setStringList(_storageKey, traits);
  }
}
