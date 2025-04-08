import 'package:char_creator/features/5e/character/models/character_5e_model_v1.dart';
import 'package:flutter/material.dart';

class AddToCharacterMenu {
  List<RadioMenuButton> generateMenuEntries(
    BuildContext context,
    List<Character5eModelV1> characters,
    String? selectedCharacterId,
    Function(String? newId) onChanged,
  ) {
    return characters
        .map(
          (character) => RadioMenuButton<String?>(
            value: character.id,
            groupValue: selectedCharacterId,
            closeOnActivate: false,
            onChanged: (String? value) {
              if (selectedCharacterId == character.id) {
                onChanged(null);
              }
              onChanged(value);
            },
            child: Text(character.name),
          ),
        )
        .toList()
      ..add(
        RadioMenuButton<String?>(
          value: null,
          groupValue: selectedCharacterId,
          closeOnActivate: false,
          onChanged: (String? value) {
            onChanged(null);
          },
          child: const Text('None'),
        ),
      );
  }
}
