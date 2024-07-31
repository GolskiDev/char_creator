import 'package:flutter/material.dart';

import 'character_trait.dart';

class CharacterTraitPage extends StatelessWidget {
  const CharacterTraitPage({
    required this.trait,
    super.key,
  });
  final SingleValueCharacterTrait trait;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(trait.id),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(trait.value),
      ),
    );
  }
}
