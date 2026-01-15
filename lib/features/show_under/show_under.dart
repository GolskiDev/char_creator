import 'package:flutter/material.dart';

/// ShowUnder is a system, where you have some Data and would like to present it under another target widget.
/// The target widget has it's name.

abstract interface class ShowUnderTarget {
  String get targetName;
}

final data = {
  "title": "Hello World",
  "description": "This is a description",
  "imageUrl": "https://example.com/image.png",
  "items": [
    {
      "title": "Item 1",
      "description": "This is item 1",
      "showUnder": "character.details",
    },
    {
      "title": "Item 2",
      "description": "This is item 2",
      "showUnder": "character.someOtherPlace",
    },
    {
      "title": "Item 3",
      "description": "This is item 3",
      "showUnder": "character.details",
    }
  ],
};

class ExampleItem {
  ExampleItem({
    required this.title,
    required this.description,
    required this.showUnder,
  });

  final String title;
  final String description;
  final String showUnder;
}

class ShowUnderDataProvider extends InheritedWidget {
  const ShowUnderDataProvider({
    required this.targetName,
    required this.data,
    required super.child,
    super.key,
  });

  final String targetName;
  final List<ExampleItem> data;

  static ShowUnderDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShowUnderDataProvider>();
  }

  @override
  bool updateShouldNotify(covariant ShowUnderDataProvider oldWidget) {
    return oldWidget.data != data || oldWidget.targetName != targetName;
  }
}

class CharacterDetails extends StatelessWidget {
  const CharacterDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final showUnder = ShowUnderDataProvider.maybeOf(context);

    return Card(
      child: Column(
        children: [
          const Text("Character Details"),
          if (showUnder != null)
            ...showUnder.data.map(
              (item) => ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
              ),
            )
        ],
      ),
    );
  }
}

class CharacterSomeOtherPlace extends StatelessWidget {
  const CharacterSomeOtherPlace({super.key});

  @override
  Widget build(BuildContext context) {
    final showUnder = ShowUnderDataProvider.maybeOf(context);

    return Card(
      child: Column(
        children: [
          const Text("Character Some Other Place"),
          if (showUnder != null)
            ...showUnder.data.map(
              (item) => ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
              ),
            )
        ],
      ),
    );
  }
}

class ShowUnderExample extends StatelessWidget {
  const ShowUnderExample({super.key});

  @override
  Widget build(BuildContext context) {
    final items = (data['items'] as List)
        .map(
          (e) => ExampleItem(
            title: e['title'] as String,
            description: e['description'] as String,
            showUnder: e['showUnder'] as String,
          ),
        )
        .toList();

    final detailsItems =
        items.where((item) => item.showUnder == 'character.details').toList();
    final someOtherPlaceItems = items
        .where((item) => item.showUnder == 'character.someOtherPlace')
        .toList();

    return Column(
      children: [
        ShowUnderDataProvider(
          targetName: 'character.details',
          data: detailsItems,
          child: const CharacterDetails(),
        ),
        ShowUnderDataProvider(
          targetName: 'character.someOtherPlace',
          data: someOtherPlaceItems,
          child: const CharacterSomeOtherPlace(),
        ),
      ],
    );
  }
}
