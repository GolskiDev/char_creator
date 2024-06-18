import 'package:flutter/material.dart';

import '../basic_chat_support/chat_widget.dart';

class ListOfAllWidgets extends StatelessWidget {
  const ListOfAllWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final listOfWidgets = [
      const Scaffold(
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
              constraints: const BoxConstraints(
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
          }).toList(),
        ),
      ),
    );
  }
}
