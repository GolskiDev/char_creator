import 'package:char_creator/work_in_progress/character_trait.dart';
import 'package:flutter/material.dart';

final exampleSingleTraits = [
  SingleValueCharacterTrait(id: "nickname", value: "Joshua"),
  SingleValueCharacterTrait(id: "race", value: "Human"),
];

class ListOfCharacterTraitsWidget extends StatelessWidget {
  const ListOfCharacterTraitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, index) => _characterTrait(
        context,
        exampleSingleTraits[index],
      ),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: exampleSingleTraits.length,
    );
  }

  _characterTrait(BuildContext context, SingleValueCharacterTrait trait) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trait.id),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(trait.value),
          ),
        ],
      ),
    );
  }
}
