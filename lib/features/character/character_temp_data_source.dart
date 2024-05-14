import 'character.dart';

class CharacterTempDataSource {
  List<Character> characters = [];

  void addCharacter(Character character) {
    try {
      characters.add(character);
    } catch (e) {
      // Handle the exception here
      print('Error adding character: $e');
    }
  }

  void updateCharacter(Character character) {
    try {
      int index = characters.indexWhere((element) => element.id == character.id);
      if (index != -1) {
        characters[index] = character;
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
    } catch (e) {
      // Handle the exception here
      print('Error removing character: $e');
    }
  }

  List<Character> getAllCharacters() {
    return characters;
  }
}