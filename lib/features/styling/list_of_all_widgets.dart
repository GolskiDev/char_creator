import 'package:char_creator/features/basic_chat_support/chat_widget.dart';
import 'package:char_creator/features/character/character_widget.dart';
import 'package:char_creator/features/prompt_list/prompt_list_widget.dart';
import 'package:flutter/material.dart';

import '../character/character.dart';

class ListOfAllWidgets extends StatelessWidget {
  const ListOfAllWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfWidgets = [
      CharacterWidget(
          character: Character(
        id: '1',
        name: 'Gandalf',
      )),
      PromptListWidget(),
      Scaffold(
        body: ChatWidget(),
      )
    ];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Wrap(
            spacing: 40,
            runSpacing: 40,
            children: listOfWidgets.map((widget) {
              return Container(
                constraints: BoxConstraints(
                  maxWidth: 400,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                child: AspectRatio(
                  aspectRatio: 1 / 2,
                  child: widget,
                ),
              );
            }).toList()),
      ),
    );
  }
}
