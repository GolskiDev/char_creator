import 'dart:async';

import 'character.dart';

class CharacterTempDataSource {
  List<Character> characters = [];
  final StreamController<List<Character>> _streamController =
      StreamController.broadcast();

  void addCharacter(Character character) {
    try {
      characters.add(character);
      _updateStream();
    } catch (e) {
      // Handle the exception here
      print('Error adding character: $e');
    }
  }

  void updateCharacter(Character character) {
    try {
      int index =
          characters.indexWhere((element) => element.id == character.id);
      if (index != -1) {
        characters[index] = character;
        _updateStream();
      } else {
        throw Exception('Character not found');
      }
    } catch (e) {
      // Handle the exception here
      print('Error updating character: $e');
    }
  }

  void removeCharacter(Character character) {
    try {
      characters.remove(character);
      _updateStream();
    } catch (e) {
      // Handle the exception here
      print('Error removing character: $e');
    }
  }

  Stream<List<Character>> getAllCharactersStream() {
    Future.delayed(Duration(milliseconds: 100), () {
      _updateStream();
    });
    return _streamController.stream;
  }

  Future<void> _updateStream() async {
    _streamController.add(characters);
  }
}
