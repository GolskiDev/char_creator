import 'package:flutter/material.dart';
import 'character.dart';

class CharacterWidget extends StatelessWidget {
  final Character character;

  CharacterWidget({required this.character});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              character.name ?? 'Unknown',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text('Race: ${character.race ?? 'Unknown'}'),
            Text('Class: ${character.characterClass ?? 'Unknown'}'),
            Text('Alignment: ${character.alignment ?? 'Unknown'}'),
            Text('Appearance: ${character.appearance ?? 'Unknown'}'),
            Text('History: ${character.characterHistory ?? 'Unknown'}'),
            Text('Skills: ${character.skills?.join(', ') ?? 'Unknown'}'),
            Text('Equipment: ${character.equipment?.join(', ') ?? 'Unknown'}'),
            Text(
                'Personality Traits: ${character.personalityTraits?.join(', ') ?? 'Unknown'}'),
            Text('Ideals: ${character.ideals?.join(', ') ?? 'Unknown'}'),
            Text('Bonds: ${character.bonds?.join(', ') ?? 'Unknown'}'),
            Text('Flaws: ${character.flaws?.join(', ') ?? 'Unknown'}'),
            Text(
                'Allies and Organizations: ${character.alliesAndOrganizations?.join(', ') ?? 'Unknown'}'),
            Text('Treasure: ${character.treasure ?? 'Unknown'}'),
          ],
        ),
      ),
    );
  }
}
