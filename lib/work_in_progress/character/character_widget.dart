import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notes/note.dart';
import 'character.dart';
import 'field.dart';

class CharacterWidget extends HookConsumerWidget {
  const CharacterWidget({
    super.key,
    required this.character,
  });

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemCount: character.fields.length,
      itemBuilder: (context, index) {
        final field = character.fields[index];
        return _characterField(context, field);
      },
    );
  }

  Widget _characterField(BuildContext context, Field field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            field.name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: field.notes.map((note) => _noteCard(note)).toList(),
          ),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _noteCard(Note note) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(note.id),
            Text(note.value),
          ],
        ),
      ),
    );
  }
}
